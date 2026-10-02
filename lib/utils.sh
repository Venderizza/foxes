#!/usr/bin/env bash

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "required command not found: $1"
    exit 1
  fi
}

require_dependencies() {
  require_command fzf
  require_command python
}
