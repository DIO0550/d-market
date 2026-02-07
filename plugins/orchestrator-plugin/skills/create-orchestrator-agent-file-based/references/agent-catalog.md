# エージェントカタログ

オーケストレーターフローで使用可能なエージェント一覧。必要なものだけを選択して作成する。

## エージェント一覧

各エージェントの詳細テンプレートは `agents/` ディレクトリ内の個別ファイルを参照。

### 制御系

| エージェント | 必須度 | 推奨モデル | 役割 | テンプレート |
|-------------|-------|----------|------|-------------|
| **Orchestrator** | 必須 | 🧠 高性能 | 全体フロー制御、エージェント起動管理 | [orchestrator.md](agents/orchestrator.md) |

### 計画フェーズ

| エージェント | 必須度 | 推奨モデル | 役割 | テンプレート |
|-------------|-------|----------|------|-------------|
| **Explorer** | 推奨 | ⚡ 中程度 | コードベース・仕様書探索 | [explorer.md](agents/explorer.md) |
| **Planner** | 推奨 | 🧠 高性能 | 実装計画作成、タスク細分化 | [planner.md](agents/planner.md) |
| **Plan Reviewer** | オプション | 🧠 高性能 | 計画の妥当性検証 | [plan-reviewer.md](agents/plan-reviewer.md) |

### 実装フェーズ

| エージェント | 必須度 | 推奨モデル | 役割 | テンプレート |
|-------------|-------|----------|------|-------------|
| **Task Manager** | 推奨 | ⚡ 中程度 | タスクライフサイクル管理（実装→レビュー→判定） | [task-manager.md](agents/task-manager.md) |
| **Implementer** | 必須（変更時） | ⚡ 中程度 | 計画に基づくコード実装（1タスク=1エージェント） | [implementer.md](agents/implementer.md) |

### 検証フェーズ

| エージェント | 必須度 | 推奨モデル | 役割 | テンプレート |
|-------------|-------|----------|------|-------------|
| **Code Reviewer** | オプション | 🧠 高性能 | 実装コードのレビュー | [code-reviewer.md](agents/code-reviewer.md) |
| **Test Runner** | 推奨 | 💨 軽量 | テスト実行と結果報告 | [test-runner.md](agents/test-runner.md) |
| **Linter** | 推奨 | 💨 軽量 | Lint & 型チェック実行 | [linter.md](agents/linter.md) |
| **Security Scanner** | オプション | ⚡ 中程度 | セキュリティ脆弱性チェック | [security-scanner.md](agents/security-scanner.md) |

### 修正フェーズ

| エージェント | 必須度 | 推奨モデル | 役割 | テンプレート |
|-------------|-------|----------|------|-------------|
| **Debugger** | オプション | 🧠 高性能 | エラー原因調査、修正提案 | [debugger.md](agents/debugger.md) |
| **Refactorer** | オプション | ⚡ 中程度 | コード改善・リファクタリング | [refactorer.md](agents/refactorer.md) |

### Git フェーズ

| エージェント | 必須度 | 推奨モデル | 役割 | テンプレート |
|-------------|-------|----------|------|-------------|
| **Committer** | 用途次第 | 💨 軽量 | Gitコミット作成 | [committer.md](agents/committer.md) |
| **PR Creator** | オプション | 💨 軽量 | Pull Request作成 | [pr-creator.md](agents/pr-creator.md) |

---

## モデル選択ガイド

### モデルクラスの説明

| クラス | 記号 | 特徴 | 用途 |
|--------|-----|------|------|
| **高性能** | 🧠 | 高い判断力・分析力 | 設計、レビュー、複雑な問題解決 |
| **中程度** | ⚡ | バランス型 | コード生成、探索、分析 |
| **軽量** | 💨 | 高速・低コスト | 定型作業、コマンド実行 |

### ツール別のモデル名

| クラス | Claude Code | Copilot | Codex |
|--------|-------------|---------|-------|
| 🧠 高性能 | `opus` | GPT-4o | o3 |
| ⚡ 中程度 | `sonnet` | GPT-4o-mini | o3-mini |
| 💨 軽量 | `haiku` | GPT-4o-mini | o3-mini |

### モデル選択の理由

#### 🧠 高性能モデルを使うエージェント

| エージェント | 理由 |
|-------------|------|
| Orchestrator | 全体の判断、エージェント選択、エラー時の対応判断 |
| Planner | 設計判断、タスク分割の粒度決定、仕様解釈 |
| Plan Reviewer | 計画の妥当性評価、リスク分析 |
| Code Reviewer | コード品質判断、バグ・セキュリティ問題の検出 |
| Debugger | 複雑なエラーの根本原因分析 |

#### ⚡ 中程度モデルを使うエージェント

| エージェント | 理由 |
|-------------|------|
| Explorer | パターン認識、関連ファイルの判断 |
| Task Manager | サブエージェント管理、判定、リトライ制御 |
| Implementer | コード生成、既存パターンの踏襲 |
| Refactorer | コード改善、パターン適用 |
| Security Scanner | 脆弱性パターンの検出 |

#### 💨 軽量モデルを使うエージェント

| エージェント | 理由 |
|-------------|------|
| Test Runner | コマンド実行、出力解析（定型的） |
| Linter | コマンド実行、出力解析（定型的） |
| Committer | コミットメッセージ生成（テンプレートベース） |
| PR Creator | PR本文生成（テンプレートベース） |

---

## 依存関係図

```
                    ┌─────────────────┐
                    │  Orchestrator   │ 🧠
                    └───────┬─────────┘
                            │
         ┌──────────────────┼──────────────────┐
         │                  │                  │
         ▼                  ▼                  ▼
   ┌──────────┐      ┌──────────┐      ┌────────────┐
   │ Explorer │ ⚡    │ Planner  │ 🧠 ←── │Plan Reviewer│ 🧠
   └────┬─────┘      └────┬─────┘      └────────────┘
        │                 │
        └────────┬────────┘
                 ▼
        ┌──────────────┐
        │ Task Manager │ ⚡  ← タスクごとに1つ起動
        └──────┬───────┘
               │
       ┌───────┴───────┐
       │               │
       ▼               ▼
┌─────────────┐ ┌─────────────┐
│ Implementer │ │Code Reviewer│
│     ⚡      │ │     🧠      │
└─────────────┘ └─────────────┘
               │
     ┌─────────┼─────────┬──────────┐
     │         │         │          │
     ▼         ▼         ▼          ▼
┌────────┐┌────────┐┌──────────┐┌────────────┐
│  Test  ││ Linter ││ Security ││ Refactorer │
│ Runner ││   💨   ││ Scanner  ││     ⚡      │
│   💨   │└────────┘│    ⚡    │└────────────┘
└───┬────┘          └────┬─────┘
    │                    │
    └─────────┬──────────┘
              │
              ▼
        ┌──────────┐
        │ Debugger │ 🧠
        └──────────┘
              │
              ▼
        ┌──────────┐
        │Committer │ 💨
        └────┬─────┘
             │
             ▼
        ┌──────────┐
        │PR Creator│ 💨
        └──────────┘
```

---

## プリセット構成

### Minimal（最小構成）
コード実装のみ、検証なし
- Orchestrator 🧠
- Planner 🧠
- Implementer ⚡

### Standard（標準構成）
テスト・Lint付きの実装
- Orchestrator 🧠
- Explorer ⚡
- Planner 🧠
- Implementer ⚡
- Task Manager ⚡
- Test Runner 💨
- Linter 💨
- Committer 💨

### Full（フル構成）
全エージェント使用
- 全14種類（🧠×5, ⚡×5, 💨×4）

### Review-Heavy（レビュー重視）
品質重視のフロー（高性能モデル多め）
- Orchestrator 🧠
- Explorer ⚡
- Planner 🧠
- Plan Reviewer 🧠
- Implementer ⚡
- Task Manager ⚡
- Code Reviewer 🧠
- Test Runner 💨
- Linter 💨
- Security Scanner ⚡
- Committer 💨
- PR Creator 💨

### Debug-Focused（デバッグ重視）
問題解決フロー
- Orchestrator 🧠
- Explorer ⚡
- Debugger 🧠
- Implementer ⚡
- Task Manager ⚡
- Test Runner 💨
- Committer 💨

---

## 出力ディレクトリ構造

オーケストレーターフローで使用する標準ディレクトリ:

```
.orchestrator/
├── plans/           # 計画書（Planner出力）
├── exploration/     # 探索結果（Explorer出力）
├── reviews/         # レビュー結果（Plan Reviewer, Code Reviewer出力）
├── logs/            # 実装ログ（Implementer, Refactorer出力）
├── results/         # テスト・Lint結果（Test Runner, Linter, Security Scanner出力）
└── debug/           # デバッグレポート（Debugger出力）
```

---

## 選択ガイド

### 「どのエージェントが必要？」判断フロー

```
新規実装？
├── Yes → Planner 🧠 + Implementer ⚡ 必須
│         └── テスト書く？ → Yes → Test Runner 💨 追加
└── No
    ├── バグ修正？ → Debugger 🧠 + Implementer ⚡
    ├── リファクタリング？ → Code Reviewer 🧠 + Refactorer ⚡
    └── レビュー対応？ → Implementer ⚡ のみ
```

### プロジェクトの成熟度で選ぶ

| 成熟度 | 推奨構成 | コスト |
|-------|---------|-------|
| MVP/プロトタイプ | Minimal | 低（🧠×2, ⚡×1） |
| 開発中 | Standard | 中（🧠×2, ⚡×3, 💨×3） |
| 本番運用中 | Review-Heavy | 高（🧠×4, ⚡×4, 💨×4） |
| レガシー改善 | Debug-Focused | 中（🧠×2, ⚡×3, 💨×2） |
