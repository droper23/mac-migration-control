#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"
command -v gh >/dev/null || { echo 'Install GitHub CLI first: brew install gh'; exit 1; }
command -v claude >/dev/null || { echo 'Claude Code is not on PATH.'; exit 1; }
gh auth status >/dev/null
git init -b main
git add -A
git commit -m 'Create Mac migration controller' || true
gh repo create mac-migration-control --private --source=. --remote=origin --push
mkdir -p "$HOME/Library/LaunchAgents"
PLIST="$HOME/Library/LaunchAgents/com.derek.mac-migration-m3.plist"
cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>Label</key><string>com.derek.mac-migration-m3</string>
<key>ProgramArguments</key><array><string>$ROOT/worker.sh</string><string>m3</string><string>claude</string></array>
<key>StartInterval</key><integer>60</integer>
<key>RunAtLoad</key><true/>
<key>StandardOutPath</key><string>$ROOT/reports/m3/launchd.out</string>
<key>StandardErrorPath</key><string>$ROOT/reports/m3/launchd.err</string>
</dict></plist>
EOF
launchctl bootout gui/$(id -u) "$PLIST" 2>/dev/null || true
launchctl bootstrap gui/$(id -u) "$PLIST"
echo
echo 'Run this on the old M4:'
echo "git clone $(git remote get-url origin) ~/Developer/mac-migration-control && cd ~/Developer/mac-migration-control && ./install-reference-worker.sh"
