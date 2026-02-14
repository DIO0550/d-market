#!/usr/bin/env bash
# Powerline-style status line for Claude Code
# Displays: path, git branch, changes, model, duration, context usage
# Requires: jq, git, Nerd Font compatible terminal

INPUT=$(cat)

# ── Parse JSON ──
MODEL_DISPLAY=$(echo "$INPUT" | jq -r '.model.display_name // "Unknown"')
MODEL_ID=$(echo "$INPUT" | jq -r '.model.id // ""')
CTX_PCT=$(echo "$INPUT" | jq -r '.context_window.used_percentage // 0')
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')
LINES_ADDED=$(echo "$INPUT" | jq -r '.cost.total_lines_added // 0')
LINES_REMOVED=$(echo "$INPUT" | jq -r '.cost.total_lines_removed // 0')
DURATION_MS=$(echo "$INPUT" | jq -r '.cost.total_duration_ms // 0')

# ── Derived values ──

# Git branch
BRANCH=$(git -C "${CWD:-.}" branch --show-current 2>/dev/null || true)
BRANCH="${BRANCH:-—}"

# Shorten path (replace $HOME with ~, then truncate if long)
SHORT_PATH="${CWD/#$HOME/~}"
if [ "${#SHORT_PATH}" -gt 20 ]; then
  PARENT=$(basename "$(dirname "$CWD")")
  DIR=$(basename "$CWD")
  SHORT_PATH="…/${PARENT}/${DIR}"
fi

# Duration: ms → Xhr Ym
DURATION_SEC=$((DURATION_MS / 1000))
HOURS=$((DURATION_SEC / 3600))
MINUTES=$(( (DURATION_SEC % 3600) / 60 ))

# Context percentage with 1 decimal
CTX_DISPLAY=$(printf "%.1f" "$CTX_PCT")

# Model version from ID
case "$MODEL_ID" in
  *opus-4-6*|*opus-4.6*)     MODEL_VER="Opus 4.6" ;;
  *sonnet-4-5*|*sonnet-4.5*) MODEL_VER="Sonnet 4.5" ;;
  *haiku-4-5*|*haiku-4.5*)   MODEL_VER="Haiku 4.5" ;;
  *opus*)   MODEL_VER="Opus" ;;
  *sonnet*) MODEL_VER="Sonnet" ;;
  *haiku*)  MODEL_VER="Haiku" ;;
  *)        MODEL_VER="$MODEL_DISPLAY" ;;
esac

# ── Powerline characters (requires Nerd Font) ──
SEP=$(printf '\xee\x82\xb0')
BRANCH_ICON=$(printf '\xee\x82\xa0')

# ── Colors (256-color mode) — Blue + Orange accent ──
BG1=24; BG2=31; BG3=172
FG_LIGHT=255

# ANSI helpers
_bg()    { printf '\033[48;5;%dm' "$1"; }
_fg()    { printf '\033[38;5;%dm' "$1"; }
_reset() { printf '\033[0m'; }

# ── Line 1: [path] ▶ [ branch] ▶ [(+N,-N)] ──
L1=""
L1+="$(_bg $BG1)$(_fg $FG_LIGHT) ${SHORT_PATH} "
L1+="$(_fg $BG1)$(_bg $BG2)${SEP}"
L1+="$(_fg $FG_LIGHT) ${BRANCH_ICON} ${BRANCH} "
L1+="$(_fg $BG2)$(_bg $BG3)${SEP}"
L1+="$(_fg $FG_LIGHT) (+${LINES_ADDED},-${LINES_REMOVED}) "
L1+="$(_reset)"

# ── Line 2: [model] ▶ [Block: Xhr Ym] ▶ [Ctx: N.N%] ──
L2=""
L2+="$(_bg $BG1)$(_fg $FG_LIGHT) ${MODEL_VER} "
L2+="$(_fg $BG1)$(_bg $BG2)${SEP}"
L2+="$(_fg $FG_LIGHT) Block: ${HOURS}hr ${MINUTES}m "
L2+="$(_fg $BG2)$(_bg $BG3)${SEP}"
L2+="$(_fg $FG_LIGHT) Ctx: ${CTX_DISPLAY}% "
L2+="$(_reset)"

echo "$L1"
echo "$L2"
