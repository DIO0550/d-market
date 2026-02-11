#!/bin/bash
SESSION_DIR="$1"
if [ -z "$SESSION_DIR" ]; then
  echo "Usage: init-session.sh <session-dir>"
  exit 1
fi
mkdir -p "$SESSION_DIR"/{explorer,planner,plan-reviewer,implementer,code-reviewer,refactorer,task-manager,test-runner,linter,security-scanner,debugger,committer,pr-creator}
