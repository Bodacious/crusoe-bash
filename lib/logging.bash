debug(){
  if [[ "$DEBUG" == true ]]; then
    printf '[Crusoe][Debug]: %s\n' "$*" >&2
  fi
}
