#!/usr/bin/env bash

list_sessions() {
  mapfile -t backups < <(get_backups)
  
  if [[ ${#backups[@]} -eq 0 ]]; then
    echo "no saved Firefox sessions."
    exit 0
  fi
  
  local index=1
  
  for backup in "${backups[@]:0:$MAX_DISPLAY}"; do
    printf "%2d) " "$index"
    show_session_info "$backup"
    ((index++))
  done
}
