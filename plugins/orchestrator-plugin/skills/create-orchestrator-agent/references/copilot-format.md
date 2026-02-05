# GitHub Copilot カスタムエージェント形式

GitHub Copilot のカスタムエージェント定義仕様。

## ファイル配置

```
.github/agents/{agent-name}.agent.md  # リポジトリレベル
~/.copilot/agents/{name}.agent.md     # ユーザーレベル（CLI）
{org}/.github/agents/                 # 組織レベル
```

## ファイル形式

YAMLフロントマター + Markdownボディ（最大30,000文字）

```markdown
---
name: agent-name
description: "エージェントの目的と機能の説明（必須）"
target: vscode  # オプション: vscode, jetbrains, eclipse, xcode
tools: ["read", "edit", "search"]  # オプション
infer: true  # 自動選択の許可（オプション）
metadata:
  author: "your-name"
  version: "1.0"
---

エージェントへの指示をここに記述。

## タスク

このエージェントが行うべきタスクの説明。

## ワークフロー

1. 最初に行うこと
2. 次に行うこと
3. 最後に行うこと

## 制約

- してはいけないこと
- 守るべきルール
```

## フロントマターのプロパティ

| プロパティ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `name` | string | No | 表示名 |
| `description` | string | Yes | エージェントの目的と機能 |
| `target` | string | No | 対象環境 |
| `tools` | string[] | No | 使用可能なツール |
| `infer` | boolean | No | 自動選択の許可 |
| `mcp-servers` | object | No | MCPサーバー設定（組織レベルのみ） |
| `metadata` | object | No | 任意のメタデータ |

## ツール設定

```yaml
# 全ツール有効（デフォルト）
tools: ["*"]

# 特定ツールのみ
tools: ["read", "edit", "search"]

# 全ツール無効
tools: []
```

利用可能なツールエイリアス:
- `execute` - コマンド実行
- `read` - ファイル読み取り
- `edit` - ファイル編集
- `search` - 検索
- `agent` - サブエージェント
- `web` - Web アクセス
- `todo` - タスク管理

## MCP サーバー設定（組織レベルのみ）

```yaml
mcp-servers:
  my-server:
    type: stdio
    command: npx
    args: ["-y", "@my-org/my-mcp-server"]
    env:
      API_KEY: "${secrets.API_KEY}"
```

## AGENTS.md との関係

Copilot は以下のファイルも認識:
- `AGENTS.md` - リポジトリルート
- `.github/copilot-instructions.md`
- `.github/instructions/**.instructions.md`
- `CLAUDE.md`, `GEMINI.md`

## ベストプラクティス

1. **description は詳細に**: 自動選択の判断材料になる
2. **target の指定**: 特定IDE向けなら指定
3. **tools の制限**: 最小権限の原則
4. **30,000文字制限**: 本文は簡潔に、詳細はリファレンスへ
