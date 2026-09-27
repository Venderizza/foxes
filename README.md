## FOXES
script to save list of your previous firefox sessions

##### BEFORE USE
check name of your profile: `about:profiles`

0. specify folders in `firefox-session`:
```bash
# path to your firefox profile
PROFILE="$HOME/.config/mozilla/firefox/zgl8zg5n.default"

# path to backups folder
BACKUP_DIR="$HOME/main/self/firefox-sessions-backups"
```

##### HOW TO USE
*dependencies:* `fzf`, `python`

1. make file executable
```bash
chmod +x firefox-session
```

2. to show options
```bash 
firefox-session *
```

