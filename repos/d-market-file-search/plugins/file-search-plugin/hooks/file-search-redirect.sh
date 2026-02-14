#!/bin/bash
# ファイル検索をTask toolのサブエージェントにリダイレクトするフック
# PreToolUse: Glob, Grep

# stdinからツール入力を読み取り
input=$(cat)

# 検索パターンを抽出してログ用に保存
pattern=$(echo "$input" | grep -oE '"pattern"\s*:\s*"[^"]*"' | head -1 || echo "")

echo "🔍 ファイル検索を検出しました。"
echo ""
echo "直接Glob/Grepを使用する代わりに、Task toolでfile-searchエージェントを使用してください："
echo ""
echo "Task tool:"
echo "  subagent_type: \"Explore\""
echo "  description: \"ファイル検索\""
echo "  prompt: |"
echo "    ファイル検索エージェントとして検索を実行してください。"
echo "    "
echo "    検索対象: {検索したい内容}"
echo "    "
echo "    plugins/file-search-plugin/agents/file-search-agent.md の指示に従い、"
echo "    結果を構造化して報告してください。"
echo ""
echo "【メリット】"
echo "- 言語固有の除外パターン自動適用"
echo "- 検索結果の関連度分析"
echo "- 構造化されたレポート出力"
echo ""

# exit 2: ユーザーに確認を求める（ブロックするが続行可能）
exit 2
