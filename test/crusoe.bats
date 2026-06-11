#!/usr/bin/env bats

setup() {
  repo_root="$(cd -- "$BATS_TEST_DIRNAME/.." && pwd -P)"
  crusoe="$repo_root/bin/crusoe"
  entries_dir="$BATS_TEST_TMPDIR/entries"
  fake_bin="$BATS_TEST_TMPDIR/bin"
  git_log="$BATS_TEST_TMPDIR/git.log"

  mkdir -p "$entries_dir" "$fake_bin"

  real_gdate="$(command -v gdate || true)"
  if [[ -z "$real_gdate" ]] && date --version >/dev/null 2>&1; then
    real_gdate="$(command -v date)"
  fi

  export REAL_GDATE="$real_gdate"
  export CRUSOE_ENTRIES_DIR="$entries_dir"
  export CRUSOE_GIT_LOG="$git_log"
  export EDITOR="$fake_bin/editor"
  export PATH="$fake_bin:$PATH"

  cat >"$fake_bin/gdate" <<'SCRIPT'
#!/usr/bin/env bash
if [[ -z "${REAL_GDATE:-}" ]]; then
  printf 'No GNU date executable available for tests\n' >&2
  exit 127
fi

exec "$REAL_GDATE" "$@"
SCRIPT

  cat >"$fake_bin/editor" <<'SCRIPT'
#!/usr/bin/env bash
printf 'edited by test editor\n' >>"$1"
SCRIPT

  cat >"$fake_bin/git" <<'SCRIPT'
#!/usr/bin/env bash
printf 'git %s\n' "$*" >>"${CRUSOE_GIT_LOG:?}"
SCRIPT

  chmod +x "$fake_bin/gdate" "$fake_bin/editor" "$fake_bin/git"
}

@test "help loads the help command file and prints usage" {
  run bash -c '"$1" --help 2>&1' _ "$crusoe"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Crusoe usage:"* ]]
  [[ "$output" == *"crusoe journal --today"* ]]
  [[ "$output" == *"crusoe read --yesterday"* ]]
}

@test "help works when crusoe is called outside the project directory" {
  run bash -c 'cd "$2" && "$1" --help 2>&1' _ "$crusoe" "$BATS_TEST_TMPDIR"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Crusoe usage:"* ]]
}

@test "unknown sub-command prints usage and exits 2" {
  run bash -c '"$1" nope 2>&1' _ "$crusoe"

  [ "$status" -eq 2 ]
  [[ "$output" == *"Unknown sub-command nope"* ]]
  [[ "$output" == *"Crusoe usage:"* ]]
}

@test "read prints an existing entry for an explicit date" {
  mkdir -p "$entries_dir/2026/06"
  printf 'Today I wrote tests.\n' >"$entries_dir/2026/06/2026-06-10.md"

  run "$crusoe" read --date=2026-06-10

  [ "$status" -eq 0 ]
  [ "$output" = "Today I wrote tests." ]
}

@test "read returns nonzero when the entry does not exist" {
  run bash -c '"$1" read --date=2026-06-10 2>&1' _ "$crusoe"

  [ "$status" -eq 1 ]
  [[ "$output" == *"Crusoe: No entry for 2026-06-10"* ]]
}

@test "journal creates the dated entry, opens the editor, and commits changes" {
  run "$crusoe" journal --date=2026-06-10

  [ "$status" -eq 0 ]
  [ -f "$entries_dir/2026/06/2026-06-10.md" ]
  [ "$(cat "$entries_dir/2026/06/2026-06-10.md")" = "edited by test editor" ]
  grep -F "git -C $entries_dir add $entries_dir/2026/06/2026-06-10.md" "$git_log" >/dev/null
  grep -F "git -C $entries_dir commit -m Update journal for 2026-06-10" "$git_log" >/dev/null
  grep -F "git -C $entries_dir push origin main" "$git_log" >/dev/null
}

@test "journal accepts --yesterday" {
  expected_date="$(gdate --date yesterday +%F)"
  expected_month="$(gdate --date "$expected_date" +%Y/%m)"

  run "$crusoe" journal --yesterday

  [ "$status" -eq 0 ]
  [ -f "$entries_dir/$expected_month/$expected_date.md" ]
}
