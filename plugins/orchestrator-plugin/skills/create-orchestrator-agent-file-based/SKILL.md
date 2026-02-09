---
name: create-orchestrator-agent-file-based
description: "オーケストレーターフロー用のエージェント定義ファイルを作成（ファイルベース出力版）。エージェント間の結果受け渡しに .orchestrator/ ディレクトリへのファイル出力を使用。Claude Code、GitHub Copilot、OpenAI Codex の各フォーマットに対応。13種類のエージェントテンプレートから必要なものだけを選択して作成可能。ツール非依存の汎用的な指示形式。「エージェント作成」「オーケストレーターにエージェント追加」などのリクエスト時に使用。"
---

# Create Orchestrator Agent

オーケストレーターフローで使用するエージェント定義ファイルを作成するスキル。

## ワークフロー

```
1. ターゲットツール確認 → Claude Code / Copilot / Codex
2. エージェント選択 → カタログから必要なものを選ぶ
3. テンプレート参照 → 個別ファイルから詳細を確認
4. ツール別の調整 → 操作名をツール固有の形式に変換
5. エージェント定義の生成 → 適切なディレクトリに配置
6. テンプレートの配置 → .orchestrator/templates/ にコピー
```

## Step 1: ターゲットツール確認

まずどのツール向けかを確認:

| ツール | 形式 | 配置先 | サブエージェント呼び出し |
|--------|------|--------|------------------------|
| Claude Code | YAML + Markdown | `.claude/agents/` | `Task` ツール |
| GitHub Copilot | YAML + Markdown | `.github/agents/` | `#tool:agent/runSubagent` (agentName指定) |
| OpenAI Codex | 純粋 Markdown | `AGENTS.md` | 別ファイル参照 |

フォーマット詳細:
- [claude-code-format.md](references/claude-code-format.md)
- [copilot-format.md](references/copilot-format.md)
- [codex-format.md](references/codex-format.md)

## Step 2: エージェント選択

[agent-catalog.md](references/agent-catalog.md) を参照し、必要なエージェントを選択。

### プリセット

| プリセット | エージェント | 用途 |
|-----------|-------------|------|
| **Minimal** | Orchestrator, Planner, Implementer | 最小限 |
| **Standard** | + Explorer, Test Runner, Linter, Committer | 一般的 |
| **Full** | 全14種類 | フル機能 |

### 個別選択

**制御**: [Orchestrator](references/agents/orchestrator.md)

**計画**: [Explorer](references/agents/explorer.md), [Planner](references/agents/planner.md), [Plan Reviewer](references/agents/plan-reviewer.md)

**実装**: [Implementer](references/agents/implementer.md), [Task Manager](references/agents/task-manager.md)

**検証**: [Code Reviewer](references/agents/code-reviewer.md), [Test Runner](references/agents/test-runner.md), [Linter](references/agents/linter.md), [Security Scanner](references/agents/security-scanner.md)

**修正**: [Debugger](references/agents/debugger.md), [Refactorer](references/agents/refactorer.md)

**Git**: [Committer](references/agents/committer.md), [PR Creator](references/agents/pr-creator.md)

### モデル選択

各エージェントには推奨モデルが設定されている:

| クラス | 記号 | エージェント | 用途 |
|--------|-----|-------------|------|
| 🧠 高性能 | opus相当 | Orchestrator, Planner, Plan Reviewer, Code Reviewer, Debugger | 判断・設計・レビュー |
| ⚡ 中程度 | sonnet相当 | Explorer, Implementer, Refactorer, Security Scanner | 分析・コード生成 |
| 💨 軽量 | haiku相当 | Test Runner, Linter, Committer, PR Creator | 定型作業・コマンド実行 |

詳細は [agent-catalog.md](references/agent-catalog.md) の「モデル選択ガイド」を参照。

## Step 3: テンプレート参照

各テンプレートには以下が含まれる:
- エージェント定義（フロントマター + 本文）
- 実行手順
- **必要な操作**（汎用的な表現）
- 入出力形式
- 完了条件

## Step 4: ツール別の調整

テンプレートの「必要な操作」をターゲットツールの形式に変換する。

詳細は [tool-mapping.md](references/tool-mapping.md) を参照:
- 汎用操作名 → ツール固有名の対応表
- サブエージェント呼び出しの変換方法
- エージェント別の使用操作一覧

## Step 5: エージェント定義の生成

### 配置先

| ツール | ディレクトリ |
|--------|-------------|
| Claude Code | `plugins/.../agents/{name}.md` または `.claude/agents/{name}.md` |
| Copilot | `.github/agents/{name}.agent.md` |
| Codex | `{name}/AGENTS.md` または ルート追記 |

## Step 6: テンプレートの配置

エージェントがランタイムで出力フォーマットを参照できるよう、テンプレートを作業ディレクトリに配置する。

```bash
mkdir -p .orchestrator/templates
```

以下の各テンプレートファイルを Read し、`.orchestrator/templates/` に同名で Write する:

- [exploration-result.md](references/templates/exploration-result.md)
- [implementation-plan.md](references/templates/implementation-plan.md)
- [code-review-result.md](references/templates/code-review-result.md)
- [test-result.md](references/templates/test-result.md)
- [plan-review-result.md](references/templates/plan-review-result.md)
- [task-lifecycle-result.md](references/templates/task-lifecycle-result.md)
- [tasks.md](references/templates/tasks.md)

## 出力ディレクトリ構造

エージェント間で共有する標準ディレクトリ:

```
.orchestrator/
├── templates/       # 出力フォーマットテンプレート
├── plans/           # Planner
├── exploration/     # Explorer
├── reviews/         # Plan Reviewer, Code Reviewer
├── logs/            # Implementer, Refactorer
├── results/         # Test Runner, Linter, Security Scanner
└── debug/           # Debugger
```

## 生成後チェックリスト

- [ ] ターゲットツールの形式に従っている
- [ ] description にトリガー条件が含まれている
- [ ] **model が適切に設定されている**（🧠/⚡/💨）
- [ ] 操作がツール固有の形式に変換されている
- [ ] サブエージェント呼び出しが正しい形式
- [ ] 入出力パスが一貫している
