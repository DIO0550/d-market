# Orchestration Skill

タスクを専門エージェントに分散して並列実行するオーケストレーションワークフロー。

## トリガー

- `/orchestrate` コマンドが実行されたとき
- ユーザーが「テスト実行して」「Lint実行して」「コミットして」「PR作って」と指示したとき

## ワークフロー概要

```
[Phase 1: 探索・計画] ───────────────────────────────
    │
    ├── planner (バックグラウンド)
    │   └── タスクを分析し実装計画を作成
    │
    └── explorer (バックグラウンド・並列)
        └── 関連ファイルを探索
    │
    ▼ (両方完了待ち → 計画をユーザーに提示)
    │
[Phase 2: 実装（タスク駆動）] ─────────────────────────
    │
    ├── TaskList でブロック解除済みタスクを確認
    ├── implementer (バックグラウンド)
    │   └── ブロック解除済みタスクを順番に実装
    │   └── 各タスク完了時に TaskUpdate で completed に更新
    │   └── 新たにブロック解除されたタスクに着手
    │
    ▼ (全タスク完了 → 結果をユーザーに報告)
    │
    ★ 自動実行停止
    │
[Phase 3: 検証] ─────────────── ユーザー指示で実行
    │
    ├── test-runner (バックグラウンド)
    └── linter (バックグラウンド・並列)
    │
[Phase 4: Git操作] ────────────── ユーザー指示で実行
    │
    ├── committer (バックグラウンド)
    └── pr-creator (バックグラウンド)
```

## 中間ファイル

オーケストレーションでは `.orchestrator/` ディレクトリを使用してエージェント間で情報を共有する：

| ファイル | 内容 | 作成者 |
|---------|------|-------|
| `.orchestrator/plan.md` | 実装計画 | planner |
| `.orchestrator/exploration.md` | 探索結果 | explorer |
| `.orchestrator/implementation-log.md` | 実装ログ | implementer |
| `.orchestrator/test-results.md` | テスト結果 | test-runner |
| `.orchestrator/lint-results.md` | Lint結果 | linter |

## エージェント起動パターン

### 並列起動（依存関係なし）

```
Phase 1: planner + explorer を同時にバックグラウンド起動
Phase 3: test-runner + linter を同時にバックグラウンド起動
```

### 直列起動（依存関係あり）

```
Phase 1 → Phase 2: 計画完了後に実装開始
Phase 3 → Phase 4: テスト成功後にコミット
Phase 4 内: コミット → PR作成
```

## Task ツールの使い方

### バックグラウンドでエージェント起動

```
Task tool:
  description: "plannerエージェント起動"
  subagent_type: general-purpose
  run_in_background: true
  prompt: |
    あなたは planner エージェントです。
    ...
```

### エージェントの完了待ち

```
TaskOutput tool:
  task_id: "{起動時に返されたtask_id}"
  block: true
  timeout: 300000  # 5分
```

## プロジェクトタイプ検出

テスト・Lintコマンドを自動検出するロジック：

```
1. package.json が存在する場合:
   - test: npm test
   - lint: npm run lint

2. Cargo.toml が存在する場合:
   - test: cargo test
   - lint: cargo clippy

3. pyproject.toml が存在する場合:
   - test: pytest
   - lint: ruff check .

4. go.mod が存在する場合:
   - test: go test ./...
   - lint: golangci-lint run
```

## オーケストレーターの責務

1. **タスク受付**: ユーザーからの要求を受け取る
2. **タスク管理**: Plannerが登録したタスクの依存関係（blocks/blockedBy）を監視し、実行順序を制御する
3. **エージェント起動**: ブロック解除済みタスクに対して適切なエージェントを起動
4. **進捗監視**: バックグラウンドエージェントの出力を監視し、タスク完了時に次のブロック解除を確認
5. **結果統合**: 各エージェントの結果を統合してユーザーに報告
6. **エラーハンドリング**: 失敗時のリトライや代替処理の提案

## エラーハンドリング

### エージェントがタイムアウトした場合

1. TaskOutput で timeout エラーを検出
2. ユーザーに状況を報告
3. 「継続して待つ」「中断する」の選択肢を提示

### エージェントがエラーで終了した場合

1. エラー内容を確認
2. ユーザーにエラー内容を報告
3. 可能であれば修正方法を提案
4. 「リトライする」「手動で修正する」の選択肢を提示

### テストやLintが失敗した場合

1. 失敗内容をユーザーに報告
2. 「implementerで修正する」「手動で修正する」の選択肢を提示
