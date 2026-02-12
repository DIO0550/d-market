---
name: create-orchestrator-agent
description: "オーケストレーターフロー用のエージェント定義ファイルを作成。Claude Code、GitHub Copilot、OpenAI Codex の各フォーマットに対応。13種類のエージェントテンプレートから必要なものだけを選択して作成可能。ツール非依存の汎用的な指示形式。「エージェント作成」「オーケストレーターにエージェント追加」などのリクエスト時に使用。"
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

**制御**: [Orchestrator](references/agents/orchestrator.md), [Orchestrator Copilot版](references/agents/orchestrator-copilot.md)

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

## エージェント間の結果受け渡し

各エージェントはセッションフォルダ内の所定パスに結果を書き出す。Orchestrator はファイル内容をプロンプトに含めず、パスだけを渡す。各エージェントが自分で Read する。

```
.orchestrator/
├── templates/                    # 共通テンプレート（セッション外）
├── {連番}-{feature名}/           # セッションフォルダ（例: 0001-user-auth）
│   ├── explorer/
│   │   └── result.md
│   ├── planner/
│   │   ├── plan.md
│   │   └── tasks.md
│   ├── plan-reviewer/
│   │   ├── review-1.md          # ラウンドごとに連番
│   │   └── review-2.md
│   ├── implementer/
│   │   └── task-{id}/
│   │       ├── result-1.md      # ラウンドごとに連番
│   │       └── result-2.md
│   ├── code-reviewer/
│   │   └── task-{id}/
│   │       ├── review-1.md      # ラウンドごとに連番
│   │       └── review-2.md
│   ├── refactorer/
│   │   └── task-{id}/
│   │       └── result-1.md      # ラウンドごとに連番
│   ├── task-manager/
│   │   └── task-{id}/
│   │       └── lifecycle.md
│   ├── test-runner/
│   │   ├── task-{id}/
│   │   │   └── result-{round}.md  # Phase 2: タスクレベル
│   │   └── result-{round}.md      # Phase 3: セッションレベル
│   ├── linter/
│   │   ├── task-{id}/
│   │   │   └── result-{round}.md  # Phase 2: タスクレベル
│   │   └── result-{round}.md      # Phase 3: セッションレベル
│   ├── security-scanner/
│   │   └── result.md
│   ├── debugger/
│   │   ├── task-{id}/
│   │   │   └── report-{round}.md  # Phase 2: タスクレベル
│   │   └── report-{round}.md      # Phase 3: セッションレベル
│   ├── committer/
│   │   └── result.md
│   └── pr-creator/
│       └── result.md
```

## Step 6: テンプレートの配置（必須）

エージェントはランタイムで `.orchestrator/templates/` 内のテンプレートを Read して出力フォーマットを決定する。
**このステップを省略するとエージェントが正しく動作しない。必ず全ファイルをコピーすること。**

まず出力先ディレクトリを作成:

```bash
mkdir -p .orchestrator/templates
mkdir -p .orchestrator/scripts
```

次に、以下の7ファイルを **1つずつ Read → Write** でコピーする:

| # | Read 対象（このスキルの参照ファイル） | Write 先 |
|---|--------------------------------------|----------|
| 1 | [exploration-result.md](references/templates/exploration-result.md) | `.orchestrator/templates/exploration-result.md` |
| 2 | [implementation-plan.md](references/templates/implementation-plan.md) | `.orchestrator/templates/implementation-plan.md` |
| 3 | [code-review-result.md](references/templates/code-review-result.md) | `.orchestrator/templates/code-review-result.md` |
| 4 | [test-result.md](references/templates/test-result.md) | `.orchestrator/templates/test-result.md` |
| 5 | [plan-review-result.md](references/templates/plan-review-result.md) | `.orchestrator/templates/plan-review-result.md` |
| 6 | [task-lifecycle-result.md](references/templates/task-lifecycle-result.md) | `.orchestrator/templates/task-lifecycle-result.md` |
| 7 | [tasks.md](references/templates/tasks.md) | `.orchestrator/templates/tasks.md` |

**手順**: 各行について Read ツールでファイル内容を取得し、Write ツールで Write 先に書き出す。内容は一切変更しない。

### スクリプトの配置

セッション初期化スクリプトを **Read → Write** でコピーする:

| # | Read 対象（このスキルの参照ファイル） | Write 先 |
|---|--------------------------------------|----------|
| 1 | [init-session.sh](references/scripts/init-session.sh) | `.orchestrator/scripts/init-session.sh` |
| 2 | [init-task.sh](references/scripts/init-task.sh) | `.orchestrator/scripts/init-task.sh` |

コピー後、実行権限を付与:

```bash
chmod +x .orchestrator/scripts/init-session.sh .orchestrator/scripts/init-task.sh
```

## 生成後チェックリスト

- [ ] `.orchestrator/templates/` に7ファイルが配置されている
- [ ] `.orchestrator/scripts/init-session.sh` と `init-task.sh` が配置されている
- [ ] ターゲットツールの形式に従っている
- [ ] description にトリガー条件が含まれている
- [ ] **model が適切に設定されている**（🧠/⚡/💨）
- [ ] 操作がツール固有の形式に変換されている
- [ ] サブエージェント呼び出しが正しい形式
- [ ] 入出力フォーマットが一貫している
