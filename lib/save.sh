#!/usr/bin/env bash

save_session() {
  local session_name="$1"
  
  if [[ ! -d "$SESSION_BACKUPS" ]]; then
    echo "firefox sessionstore-backups folder not found:"
    echo "$SESSION_BACKUPS"
    exit 1
  fi
  
  if ! pgrep -x "firefox" >/dev/null; then
    echo "firefox is currently closed."
    echo "open firefox before saving a session."
    exit 1
  fi
  
  mkdir -p "$BACKUP_DIR"
  
  local timestamp
  timestamp=$(date +"%d-%m-%Y_%H-%M")
  
  local destination
  
  if [[ -n "$session_name" ]]; then
    destination="$BACKUP_DIR/${timestamp}_${session_name}"
  else
    destination="$BACKUP_DIR/${timestamp}_session"
  fi
  
  cp -a "$SESSION_BACKUPS" "$destination"
  
  echo "session backup created:"
  echo "$destination"
  show_session_info "$destination"
}
