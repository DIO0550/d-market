# Claude Code エージェント形式

Claude Code のサブエージェント定義仕様。

## ファイル配置

```
.claude/agents/{agent-name}.md     # プロジェクトレベル
~/.claude/agents/{agent-name}.md   # ユーザーレベル
```

## ファイル形式

YAMLフロントマター + Markdownボディ

```markdown
---
name: agent-name
description: "エージェントの説明。いつこのエージェントを使うべきかを含める"
color: cyan  # オプション: cyan, green, yellow, red, magenta, blue
---

エージェントへの指示（システムプロンプト）をここに書く。

## 実行手順

1. ステップ1の説明
2. ステップ2の説明

## 使用可能なツール

- **Read**: ファイル読み込み
- **Glob**: ファイルパターン検索
- **Grep**: コンテンツ検索

## 出力フォーマット

期待される出力形式の説明。

## 完了条件

エージェントが完了したとみなされる条件。
```

## フロントマターのプロパティ

| プロパティ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `name` | string | Yes | エージェントの識別名 |
| `description` | string | Yes | いつ使うかを含む説明（自動選択に使用） |
| `model` | string | No | 使用モデル（`opus`, `sonnet`, `haiku`） |
| `tools` | string[] | No | 使用可能なツール（省略時は全ツール有効） |
| `color` | string | No | ターミナル表示色 |

### tools の値

| 値 | 対応ツール | 用途 |
|----|-----------|------|
| `read` | Read | ファイル読み込み |
| `edit` | Edit, Write | ファイル編集・作成 |
| `search` | Glob, Grep | ファイル・コード検索 |
| `execute` | Bash | コマンド実行（テスト、Lint、git等） |
| `agent` | Task, TaskOutput | サブエージェント起動・結果取得 |
| `todo` | TaskCreate, TaskUpdate, TaskList, TaskGet | タスク管理 |
| `web` | WebSearch, WebFetch | Web検索・URL取得 |

**重要**: `execute` を含めないとエージェントは Bash を使えない。テスト実行、Lint、git操作などコマンド実行が必要なエージェントには必ず `execute` を含めること。

## Task ツールでの呼び出し

```
Task tool:
  description: "短い説明"
  subagent_type: {name}  # フロントマターの name と一致
  prompt: "追加の指示やコンテキスト"
  run_in_background: true/false
  model: sonnet/opus/haiku  # オプション
```

## ツール制限

Claude Code Agent SDK では `tools` プロパティでツールを制限可能：

```python
AgentDefinition(
    description="...",
    prompt="...",
    tools=["Read", "Grep", "Glob"],  # 読み取り専用
    model="sonnet"
)
```

利用可能なツール:
- `Read`, `Write`, `Edit` - ファイル操作
- `Glob`, `Grep` - 検索
- `Bash` - コマンド実行
- `Task` - サブエージェント起動（サブエージェントには含めない）
- `WebFetch`, `WebSearch` - Web アクセス

## ベストプラクティス

1. **明確な役割定義**: エージェントが何をするかを最初に明示
2. **具体的な手順**: 曖昧さを排除した実行ステップ
3. **出力形式の指定**: 期待される出力フォーマットを明確に
4. **完了条件**: いつ完了とみなすかを定義
5. **ツール使用ガイド**: 各ツールの使い方を説明
