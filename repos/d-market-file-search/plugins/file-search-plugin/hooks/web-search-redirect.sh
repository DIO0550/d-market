#!/bin/bash
# Web検索をTask toolのサブエージェントにリダイレクトするフック
# PreToolUse: WebSearch, WebFetch

# stdinからツール入力を読み取り
input=$(cat)

echo "🌐 Web検索を検出しました。"
echo ""
echo "直接WebSearch/WebFetchを使用する代わりに、Task toolでweb-searchエージェントを使用してください："
echo ""
echo "Task tool:"
echo "  subagent_type: \"general-purpose\""
echo "  description: \"Web検索\""
echo "  prompt: |"
echo "    Web検索エージェントとして検索を実行してください。"
echo "    "
echo "    検索対象: {検索したい内容}"
echo "    "
echo "    plugins/file-search-plugin/agents/web-search-agent.md の指示に従い、"
echo "    結果を構造化して報告してください。"
echo ""
echo "【メリット】"
echo "- 段階的検索（概要→詳細）の自動実行"
echo "- ソースの信頼性評価"
echo "- 構造化されたレポート出力"
echo ""

# exit 2: ユーザーに確認を求める（ブロックするが続行可能）
exit 2
