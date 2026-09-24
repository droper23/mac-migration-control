#!/bin/bash
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin"

ROOT="$(cd "$(dirname "$0")" && pwd)"
ROLE="${1:?role required: m3 or m4}"
AGENT="${2:?agent required: claude or codex}"
LOG_DIR="$ROOT/reports/$ROLE/logs"
LOCK_DIR="$ROOT/.runtime/$ROLE.lock"
mkdir -p "$LOG_DIR" "$ROOT/.runtime"
if ! mkdir "$LOCK_DIR" 2>/dev/null; then exit 0; fi
trap 'rmdir "$LOCK_DIR"' EXIT
cd "$ROOT"
git pull --rebase --autostash origin main >/dev/null 2>&1 || exit 0
TASK="$(grep -rl '^state: queued$' "tasks/$ROLE" 2>/dev/null | sort | head -n 1 || true)"
[ -n "$TASK" ] || exit 0
perl -0pi -e 's/^state: queued$/state: active/m' "$TASK"
git add "$TASK"
git commit -m "Claim $(basename "$TASK") on $ROLE" >/dev/null
git push origin main >/dev/null
PROMPT="You are the $ROLE worker in a two-Mac migration. Read AGENT_RULES.md, STATUS.md, and the assigned task $TASK. Work only on the task. Verify results with real checks. Keep reports factual. Write a report at reports/$ROLE/$(basename "$TASK" .md)-report.md. Update STATUS.md with completed work and blockers, then update the assigned task state to completed, blocked, or needs-review. Commit nothing: the controller commits your work."
LOG="$LOG_DIR/$(date +%Y%m%d-%H%M%S)-$(basename "$TASK" .md).log"
set +e
if [ "$AGENT" = "claude" ]; then
  claude --dangerously-skip-permissions -p "$PROMPT" >"$LOG" 2>&1
else
  codex exec --full-auto "$PROMPT" >"$LOG" 2>&1
fi
RESULT=$?
set -e
if grep -q '^state: active$' "$TASK"; then perl -0pi -e 's/^state: active$/state: needs-review/m' "$TASK"; fi
git add -A
if ! git diff --cached --quiet; then
  git commit -m "Report $(basename "$TASK") from $ROLE" >/dev/null
  git push origin main >/dev/null || true
fi
exit "$RESULT"
