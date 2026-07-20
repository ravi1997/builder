#!/usr/bin/env bash
set -euo pipefail

SESSION="team"
REPO_DIR="$(git rev-parse --show-toplevel)"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  exec tmux attach-session -t "$SESSION"
fi

tmux new-session -d -s "$SESSION" -c "$REPO_DIR" claude
tmux split-window -h -t "$SESSION:0" -c "$REPO_DIR" codex
tmux split-window -v -t "$SESSION:0.1" -c "$REPO_DIR" agy
tmux select-layout -t "$SESSION:0" main-vertical
exec tmux attach-session -t "$SESSION"
