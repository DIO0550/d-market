# /orchestrate コマンド

タスクを受け取り、専門化されたサブエージェントをバックグラウンドで並列起動してタスクを遂行する。

## 使用方法

```
/orchestrate "タスクの説明"
```

## 実行フロー

### 自動実行フェーズ（Phase 1-2）

このコマンドは以下の2フェーズを自動で実行し、実装完了後に停止する：

1. **Phase 1: 探索・計画**
   - planner と explorer を並列でバックグラウンド起動
   - 両方の完了を待ち、計画をユーザーに提示

2. **Phase 2: 実装**
   - implementer をバックグラウンド起動
   - 完了後、結果をユーザーに報告
   - **ここで自動実行は停止**

### ユーザー指示フェーズ（Phase 3-4）

以下のフェーズはユーザーの指示で実行：

3. **Phase 3: 検証** - 「テスト実行して」「Lint実行して」
4. **Phase 4: Git操作** - 「コミットして」「PR作って」

## オーケストレーターの実行手順

### Step 1: 作業ディレクトリの準備

```bash
mkdir -p .orchestrator
```

### Step 2: Phase 1 - 探索・計画の並列実行

以下の2つのエージェントを**バックグラウンドで並列起動**する：

**planner エージェント:**
```
Task tool:
  subagent_type: general-purpose
  run_in_background: true
  prompt: |
    あなたはplannerエージェントです。

    ## タスク
    以下のタスクを分析し、実装計画を作成してください：
    「{ユーザーのタスク}」

    ## 出力
    計画を `.orchestrator/plan.md` に書き出してください。

    ## 計画に含めるべき内容
    1. タスクの理解と目的
    2. 必要な変更の概要
    3. 変更対象ファイル（推測）
    4. 実装ステップ（具体的に）
    5. 注意点・リスク

    ## 利用可能なツール
    - Read: ファイル読み込み
    - Glob: ファイル検索
    - Grep: コード検索
```

**explorer エージェント:**
```
Task tool:
  subagent_type: Explore
  run_in_background: true
  prompt: |
    あなたはexplorerエージェントです。

    ## タスク
    以下のタスクに関連するファイルを探索してください：
    「{ユーザーのタスク}」

    ## 出力
    探索結果を `.orchestrator/exploration.md` に書き出してください。

    ## 探索すべき内容
    1. 関連する既存コード
    2. 類似の実装パターン
    3. 設定ファイル
    4. テストファイル
    5. ドキュメント
```

### Step 3: Phase 1 完了待ち

両方のエージェントの完了を待つ：
1. TaskOutput で planner の結果を取得
2. TaskOutput で explorer の結果を取得
3. `.orchestrator/plan.md` と `.orchestrator/exploration.md` を読み込む
4. 計画をユーザーに提示

### Step 4: Phase 2 - 実装

**implementer エージェント:**
```
Task tool:
  subagent_type: general-purpose
  run_in_background: true
  prompt: |
    あなたはimplementerエージェントです。

    ## タスク
    計画に基づいてコードを実装してください。

    ## 参照ファイル
    - 計画: `.orchestrator/plan.md`
    - 探索結果: `.orchestrator/exploration.md`

    ## 出力
    - コードを直接編集/作成
    - 実装ログを `.orchestrator/implementation-log.md` に書き出す

    ## 注意事項
    - 既存のコードスタイルに従う
    - 最小限の変更で目的を達成する
    - テストコードも必要に応じて追加
```

### Step 5: Phase 2 完了・報告

1. TaskOutput で implementer の結果を取得
2. `.orchestrator/implementation-log.md` を読み込む
3. 実装結果をユーザーに報告
4. **ここで自動実行を停止**

### Step 6: 次のステップの案内

ユーザーに以下の選択肢を提示：
- 「テストとLint実行して」→ Phase 3
- 「コミットして」→ Phase 4
- 「PR作って」→ Phase 4

## 後続フェーズの実行（ユーザー指示時）

### 「テスト実行して」「Lint実行して」への応答

**test-runner と linter を並列起動:**

プロジェクトタイプを自動検出してコマンドを決定：
- package.json → `npm test`, `npm run lint`
- Cargo.toml → `cargo test`, `cargo clippy`
- pyproject.toml → `pytest`, `ruff check`
- go.mod → `go test ./...`, `golangci-lint run`

### 「コミットして」への応答

**committer エージェントを起動**

### 「PR作って」への応答

**pr-creator エージェントを起動**

## エラーハンドリング

- エージェントがエラーで終了した場合、エラー内容をユーザーに報告
- 必要に応じてリトライを提案
- 計画の修正が必要な場合は planner を再起動
