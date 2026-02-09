#!/bin/bash
# implementation-plan / design-doc に状態マシン図・データフロー図が含まれているか検証するフック
# PreToolUse: Write
#
# 対象: *implementation-plan*.md, *design-doc*.md
# exit 0 = 許可, exit 2 = ブロック（メッセージ付き）

input=$(cat)

# file_path を抽出
file_path=$(echo "$input" | grep -oE '"file_path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')

# 対象ファイルかどうか判定
case "$file_path" in
  *implementation-plan*.md | *design-doc*.md) ;;
  *) exit 0 ;;
esac

# content を抽出（JSON文字列のエスケープを復元）
content=$(echo "$input" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    # tool_input.content or content
    c = data.get('tool_input', data).get('content', '')
    print(c)
except:
    sys.exit(1)
" 2>/dev/null)

if [ $? -ne 0 ] || [ -z "$content" ]; then
  # content取得失敗時はブロックしない
  exit 0
fi

missing=()

# --- Check 1: 状態マシンセクションヘッダー ---
if ! echo "$content" | grep -qE '^#{1,4}.*状態マシン'; then
  missing+=("状態マシン図セクション（見出し）")
fi

# --- Check 2: データフローセクションヘッダー ---
if ! echo "$content" | grep -qE '^#{1,4}.*データフロー'; then
  missing+=("データフロー図セクション（見出し）")
fi

# --- Check 3: 各セクション内に図表コンテンツがあるか ---
# ASCII罫線文字 or mermaidコードブロック
diagram_pattern='[┌┐└┘│─├┤┬┴┼▼▶▷▲◀◁→←↓↑►◄]|```mermaid'

# 状態マシンセクションの図チェック（ヘッダーが存在する場合のみ）
if echo "$content" | grep -qE '^#{1,4}.*状態マシン'; then
  # セクション開始から次の同レベル以上のヘッダーまでを抽出
  section=$(echo "$content" | sed -n '/^#\{1,4\}.*状態マシン/,/^#\{1,4\} /p' | tail -n +2)
  if ! echo "$section" | grep -qE "$diagram_pattern"; then
    missing+=("状態マシン図セクション内の図表（ASCII罫線 or mermaidブロック）")
  fi
fi

# データフローセクションの図チェック（ヘッダーが存在する場合のみ）
if echo "$content" | grep -qE '^#{1,4}.*データフロー'; then
  section=$(echo "$content" | sed -n '/^#\{1,4\}.*データフロー/,/^#\{1,4\} /p' | tail -n +2)
  if ! echo "$section" | grep -qE "$diagram_pattern"; then
    missing+=("データフロー図セクション内の図表（ASCII罫線 or mermaidブロック）")
  fi
fi

# 結果判定
if [ ${#missing[@]} -gt 0 ]; then
  echo "⚠️ implementation-plan / design-doc に必須の図表が不足しています。"
  echo ""
  echo "不足項目:"
  for item in "${missing[@]}"; do
    echo "  - $item"
  done
  echo ""
  echo "以下を含めてからファイルを書き出してください:"
  echo "  1. 「## 状態マシン図」セクション（ASCII罫線図 or mermaidブロック付き）"
  echo "  2. 「## データフロー図」セクション（ASCII罫線図 or mermaidブロック付き）"
  echo ""
  echo "例:"
  echo '  ## 状態マシン図'
  echo '  ```mermaid'
  echo '  stateDiagram-v2'
  echo '    [*] --> Idle'
  echo '    Idle --> Processing'
  echo '  ```'
  echo ""
  exit 2
fi

exit 0
