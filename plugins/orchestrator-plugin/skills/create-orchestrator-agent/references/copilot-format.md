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
# 特定ツールのみ
tools: ["read", "edit", "search"]

# 全ツール無効
tools: []
```

**注意**: VS Code では `tools: ["*"]` が機能しない。全ツールを有効にするには `tools` を省略するか、全ツールを明示的にリストすること。

### GitHub.com（Coding Agent）のツールエイリアス

ツール名は大文字小文字を区別しない。

| プライマリ | 互換エイリアス | 用途 |
|-----------|---------------|------|
| `execute` | `shell`, `Bash`, `powershell` | コマンド実行 |
| `read` | `Read`, `NotebookRead` | ファイル読み込み |
| `edit` | `Edit`, `MultiEdit`, `Write`, `NotebookEdit` | ファイル編集 |
| `search` | `Grep`, `Glob` | ファイル・テキスト検索 |
| `agent` | `custom-agent`, `Task` | サブエージェント起動 |
| `web` | `WebSearch`, `WebFetch` | Web検索・URL取得 |
| `todo` | `TodoWrite` | タスク管理 |

MCP サーバーツール: `github/*`（GitHub MCP Server）、`playwright/*`（Playwright MCP Server）

### VS Code（IDE）のツール

VS Code ではツール名が異なる。

| ツール名 | 用途 |
|---------|------|
| `search` | コード検索 |
| `codebase` | コードベース分析 |
| `fetch` | Web コンテンツ取得 |
| `githubRepo` | GitHub リポジトリアクセス |
| `usages` | コード利用箇所分析 |
| `editFiles` | ファイル編集 |
| `terminalLastCommand` | ターミナル最後のコマンド |
| `agent` | サブエージェント起動（`agent/runSubagent`） |

拡張機能・MCP サーバー提供のツールも `tools:` で指定可能（`<server-name>/*` 形式）。

## サブエージェント起動

**重要**: Copilot ではツール名を明示的に指定しないとサブエージェントを起動しない。

### 前提条件

呼び出し側のエージェントの `tools` に `agent` を含める:

```yaml
tools: ["read", "edit", "search", "agent"]
```

**注意**: 親エージェントのツール設定はサブエージェントに継承される。親で制限したツールはサブエージェントも使えなくなるため、Orchestrator のように多くのサブエージェントを起動するエージェントは全ツールを明示的にリストすること（VS Code では `["*"]` が機能しないため）。

### 呼び出し構文

エージェントの指示本文で `#tool:agent/runSubagent` を使用し、`agentName` でカスタムエージェント名を指定:

```markdown
#tool:agent/runSubagent を使って探索処理をサブエージェントで実行してください。

- prompt: {タスクの説明}
- agentName: explorer
```

#### パラメータ

| パラメータ | 必須 | 説明 |
|-----------|------|------|
| `prompt` | Yes | サブエージェントへの入力（タスクの詳細説明） |
| `description` | Yes | UI表示用の3〜5語のサマリー |
| `agentName` | No | カスタムエージェント名（大文字小文字区別）。省略するとアドホックなサブエージェントが生成される |

### VS Code 設定

カスタムエージェントをサブエージェントから呼び出すには、実験的機能のオプトインが必要:

```json
{
  "chat.customAgentInSubagent.enabled": true
}
```

- `agentName` を指定しても、この設定が無効だとカスタムエージェント定義がロードされない
- 複数のサブエージェントを同時起動可能（並列実行）

### handoffs プロパティ

VS Code / IDE 環境では `handoffs` プロパティでエージェント間遷移が可能:

```yaml
handoffs:
  - agent: implementer
    description: "実装フェーズに移行"
```

**注意**: `handoffs` は GitHub.com の Copilot coding agent では未サポート。IDE 環境のみ。

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
3. **tools の制限**: 最小権限の原則。ただし **サブエージェントを起動する親エージェント（Orchestrator 等）は全ツールを明示的にリストすること**。VS Code では `["*"]` が機能しないため、省略ではなく全ツールを個別に列挙する。親エージェントのツール設定がサブエージェントに継承されるため、親で制限するとサブエージェントもそのツールを使えなくなる
4. **30,000文字制限**: 本文は簡潔に、詳細はリファレンスへ
