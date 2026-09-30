## FOXES
a script for saving and managing previous Firefox sessions

#### BEFORE USE
check the name of your current Firefox profile at `about:profiles`

0. specify directories in `firefox-session`:
```bash
# path to the current Firefox profile
PROFILE="$HOME/.config/mozilla/firefox/zgl8zg5n.default"

# path to the backups directory
BACKUP_DIR="$HOME/main/self/firefox-sessions-backups"
```

#### HOW TO USE `[ Linux ]`
*dependencies:* `fzf`, `python`

1. make the script executable
```bash
chmod +x firefox-session
```

2. show available options
```bash 
firefox-session *
```

