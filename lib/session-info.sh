#!/usr/bin/env bash

get_session_info() {
  local backup_dir="$1"
  
  local recovery_file="$backup_dir/recovery.jsonlz4"
  
  if [[ ! -f "$recovery_file" ]]; then
    echo "0 windows, 0 tabs"
    return
  fi
  

  python - "$recovery_file" <<'PY'
import sys
import json
from pathlib import Path

try:
    import lz4.block
except ImportError:
    print("0 windows, 0 tabs")
    sys.exit(0)

path = Path(sys.argv[1])
try:
    data = path.read_bytes()
    # Mozilla JSONLZ4 header: b"mozLz40\0"
    if not data.startswith(b"mozLz40\0"):
        print("0 windows, 0 tabs")
        sys.exit(0)
    
    compressed = data[8:]
    decompressed = lz4.block.decompress(compressed)
    session = json.loads(decompressed)
    
    windows = session.get("windows", [])
    window_count = len(windows)
    tab_count = sum(len(w.get("tabs", [])) for w in windows)
    
    print(f"{window_count} windows, {tab_count} tabs")
except Exception:
    print("unknown windows, unknown tabs")
PY
}

show_session_info() {
  local backup_dir="$1"
  local name

  name=$(basename "$backup_dir")
  
  local info
  
  info=$(get_session_info "$backup_dir")
  
  echo "$info | $name"
}
