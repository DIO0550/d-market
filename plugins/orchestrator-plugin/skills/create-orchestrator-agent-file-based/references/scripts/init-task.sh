#!/bin/bash
SESSION_DIR="$1"
TASK_ID="$2"
if [ -z "$SESSION_DIR" ] || [ -z "$TASK_ID" ]; then
  echo "Usage: init-task.sh <session-dir> <task-id>"
  exit 1
fi
mkdir -p "$SESSION_DIR"/{implementer,test-runner,linter,code-reviewer,refactorer,debugger,task-manager}/task-"$TASK_ID"
