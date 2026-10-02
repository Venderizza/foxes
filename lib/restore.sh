#!/usr/bin/env bash

get_backups() {

  find "$BACKUP_DIR" \
    -mindepth 1 \
    -maxdepth 1 \
    -type d \
    -name "*" \
    -printf "%T@ %p\n" |
  sort -rn |
  cut -d' ' -f2-
}

select_session() {
  mapfile -t backups < <(get_backups)
  
  if [[ ${#backups[@]} -eq 0 ]]; then
    echo "no saved sessions"
    exit 0
  fi

  local -a names=()
  local -a infos=()
  local backup name info
  local info_width=0

  for backup in "${backups[@]:0:$MAX_DISPLAY}"; do
    name=$(basename "$backup")
    info=$(get_session_info "$backup")

    names+=("$name")
    infos+=("$info")

    if (( ${#info} > info_width )); then
      info_width=${#info}
    fi
  done

  local -a entries=()
  local index=1
  local i
  for (( i = 0; i < ${#infos[@]}; i++ )); do
    entries+=(
      "$(printf '%2d) %-*s | %s' \
        "$index" "$info_width" "${infos[i]}" "${names[i]}")"
    )
    ((index++))
  done
    
  selected=$(
    printf '%s\n' "${entries[@]}" |
    fzf \
      --height=50% \
      --layout=reverse \
      --border \
      --prompt="firefox session > " \
      --header="select session with arrows, enter to restore, esc to cancel"
  ) || exit 0
  
  local selected_index
  selected_index=$(echo "$selected" | cut -d')' -f1 | tr -d '[:space:]')
  
  restore_session "$selected_index"
}

restore_session() {
  local number="$1"
  
  mapfile -t backups < <(get_backups)
  if [[ ${#backups[@]} -eq 0 ]]; then
    echo "no saved sessions"
    exit 1
  fi
  
  if ! [[ "$number" =~ ^[0-9]+$ ]]; then
    echo "invalid session number"
    exit 1
  fi
  
  if (( number < 1 || number > ${#backups[@]} )); then
    echo "session number out of range"
    echo "available sessions: 1-${#backups[@]}"
    exit 1
  fi
  
  local selected="${backups[$((number - 1))]}"
  
  echo "selected session:"
  show_session_info "$selected"
  echo
  
  if pgrep -x firefox >/dev/null; then
    echo "firefox is currently running."
    echo "close Firefox before restoring a session."
    exit 1
  fi
  
  rm -rf "$SESSION_BACKUPS"
  rm "$PROFILE/sessionstore.jsonlz4"
  rm "$PROFILE/sessionCheckpoints.json"
  
  cp -a "$selected" "$SESSION_BACKUPS"
  
  echo "session restored."
  echo "start Firefox normally."
}
