# Orchestration Skill

タスクを専門エージェントに分散して並列実行するオーケストレーションワークフロー。

## トリガー

- `/orchestrate` コマンドが実行されたとき
- ユーザーが「テスト実行して」「Lint実行して」「コミットして」「PR作って」と指示したとき

## ワークフロー概要

```
[Phase 1: 探索・計画] ───────────────────────────────
    │
    ├── explorer (バックグラウンド)
    │   └── 関連ファイルを探索
    │
    ▼ (explorer 完了待ち)
    │
    ├── planner (バックグラウンド・探索結果を入力)
    │   └── 探索結果を基にタスクを分析し実装計画を作成
    │
    ▼ (planner 完了待ち → 計画をユーザーに提示)
    │
[Phase 2: 実装（タスクごとにtask-manager起動）] ──────────
    │
    ├── Orchestrator が TaskList でブロック解除済みタスクを確認
    ├── ブロック解除済みタスクごとに task-manager を起動
    │   ├── Task-A (blockedBy なし) → task-manager-A ─┐
    │   └── Task-B (blockedBy なし) → task-manager-B ─┤ 並列
    │   │                                             │
    │   │ task-manager 内部:                           │
    │   │   1. implementer 起動 → 実装                │
    │   │   2. code-reviewer 起動 → レビュー（任意）   │
    │   │   3. completed/rejected 判定                 │
    │   │   4. rejected → implementer 再起動（最大2回）│
    │   │                                             │
    │   ├── task-manager-A → Task-A: completed ✅
    │   └── task-manager-B → Task-B: completed ✅
    │
    ├── 新たにブロック解除されたタスクがあれば再度 task-manager を起動
    │   └── Task-C (blockedBy [A,B]) → task-manager-C
    │
    ▼ (全タスク completed → 結果をユーザーに報告)
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
| `.orchestrator/implementation-log.md` | 実装ログ（全タスク統合） | orchestrator |
| `.orchestrator/test-results.md` | テスト結果 | test-runner |
| `.orchestrator/lint-results.md` | Lint結果 | linter |

## エージェント起動パターン

### 並列起動（依存関係なし）

```
Phase 1: explorer → planner を直列でバックグラウンド起動（planner は探索結果を入力として受け取る）
Phase 2: blockedBy なしのタスクに対する task-manager を同時にバックグラウンド起動
Phase 3: test-runner + linter を同時にバックグラウンド起動
```

### 直列起動（依存関係あり）

```
Phase 1 内: explorer → planner（探索結果を計画に反映）
Phase 1 → Phase 2: 計画完了後に実装開始
Phase 2 内: blockedBy のあるタスクは前提タスクの完了を待って起動
Phase 3 → Phase 4: テスト成功後にコミット
Phase 4 内: コミット → PR作成
```

### Phase 2 の実装ループ（Orchestrator が制御）

```
while (pendingタスクが残っている):
  1. TaskList でブロック解除済み（blockedBy が空）の pending タスクを取得
  2. 各タスクに対して task-manager を1つずつバックグラウンド起動
     - 独立タスクは並列起動
     - task-manager が内部で implementer → code-reviewer → 判定を管理
     - rejected 時のリトライも task-manager 内部で処理（最大2回）
  3. TaskOutput で全 task-manager の完了を待つ
  4. 新たにブロック解除されたタスクがあれば 1 に戻る
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

## オーケストレーターの制約（厳守）

- **自分で調査・探索を行わない**: URL取得、コード検索、ファイル内容の調査など、情報収集に類する作業はすべて Explorer に委譲すること
- **ユーザーが URL（GitHub Issue、仕様書リンク等）を提示した場合**: その URL を含めて Explorer のプロンプトに渡し、Explorer に取得・分析させること。Orchestrator 自身が WebFetch や Read で内容を確認してはならない
- **Orchestrator の役割は指揮・監視・報告のみ**: エージェントの起動、進捗の監視、結果のユーザーへの報告に専念すること

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
