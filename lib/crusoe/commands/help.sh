
usage() {
  cat >&2 <<-'USAGE'
    Crusoe usage:
    # Open today's journal entry in editor
    crusoe

    crusoe journal --today
    crusoe journal --yesterday

    crusoe read
    crusoe read --today
    crusoe read --yesterday

    # See the current week Monday-Friday journals
    crusoe report
    crusoe report --from=2026/05/01 --to=2026/06/01

    # Set the Git repo for where to save daily entries
    crusoe config --set repository_url git@github.com/bodacious/crusoe-bash.git
USAGE
}

help(){
  usage
}
