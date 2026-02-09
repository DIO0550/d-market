# /orchestrate コマンド

タスクを受け取り、専門化されたサブエージェントをバックグラウンドで並列起動してタスクを遂行する。

## 使用方法

```
/orchestrate "タスクの説明"
```

## 実行フロー

**自律実行モード**: Phase 1〜2 はユーザー確認なしで自動完了する。ユーザーへの確認が必要な場合は Question 系ツール（AskUserQuestion 等）のみ使用し、それ以外では中断しない。

### 自動実行フェーズ（Phase 1-2）

このコマンドは以下の2フェーズを自動で実行し、実装完了後に停止する：

1. **Phase 1: 探索・計画**
   - explorer をバックグラウンド起動し、完了を待つ
   - 探索結果を planner のプロンプトに含めてバックグラウンド起動し、完了を待つ
   - 計画をユーザーに提示

2. **Phase 2: 実装（タスクごとにtask-managerを起動）**
   - Orchestrator が TaskList で依存関係（blockedBy）を確認
   - ブロック解除済みタスクごとに task-manager を1つ起動（独立タスクは並列）
   - task-manager が内部で implementer 起動 → code-reviewer 起動 → 完了判定を管理
   - 全タスク completed 後、結果を統合してユーザーに報告
   - **ここで自動実行は停止**

### ユーザー指示フェーズ（Phase 3-4）

以下のフェーズはユーザーの指示で実行：

3. **Phase 3: 検証** - 「テスト実行して」「Lint実行して」
4. **Phase 4: Git操作** - 「コミットして」「PR作って」

## オーケストレーターの実行手順

### Step 1: 作業ディレクトリの準備

```bash
mkdir -p .orchestrator/templates
```

### Step 2: Phase 1 - 探索（Explorer）

まず explorer を起動し、タスクに関連するコードベースの情報を収集する。

**explorer エージェント:**
```
Task tool:
  subagent_type: Explore
  run_in_background: true
  prompt: |
    あなたはexplorerエージェントです。

    ## 最初に読むべきドキュメント
    探索の前に、CLAUDE.md を読んでファイル検索の制約やルールを確認してください。

    ## タスク
    以下のタスクに関連するファイルを探索してください：
    「{ユーザーのタスク}」

    {ユーザーが URL を提示した場合は URL も含める}

    ## 出力
    探索結果を `.orchestrator/exploration.md` に書き出してください。

    ## 探索すべき内容
    1. 関連する既存コード
    2. 類似の実装パターン
    3. 設定ファイル
    4. テストファイル
    5. ドキュメント（docs/, specs/ ディレクトリを含む）
    6. ユーザーが提示した URL の内容（該当する場合）
```

### Step 3: Explorer 完了待ち → 計画（Planner）

Explorer の完了を待ち、探索結果を Planner に渡す。

```
1. TaskOutput で explorer の結果を取得
2. `.orchestrator/exploration.md` を読み込む
```

**planner エージェント:**
```
Task tool:
  subagent_type: general-purpose
  run_in_background: true
  prompt: |
    あなたはplannerエージェントです。

    ## 最初に読むべきドキュメント
    計画作成の前に、以下のドキュメントを読んでプロジェクトのガイドラインを把握してください：
    1. CLAUDE.md（プロジェクト固有ルール）
    2. README.md（プロジェクト概要）
    3. docs/ ディレクトリ配下のドキュメント（存在する場合）

    ## 探索結果
    Explorer エージェントの探索結果を参照してください：
    `.orchestrator/exploration.md`
    {または探索結果の内容を直接プロンプトに含める}

    ## タスク
    以下のタスクを分析し、探索結果を踏まえてプロジェクトガイドラインに従った実装計画を作成してください：
    「{ユーザーのタスク}」

    ## 出力
    計画を `.orchestrator/plan.md` に書き出してください。

    ## 計画に含めるべき内容
    1. タスクの理解と目的
    2. 必要な変更の概要
    3. 変更対象ファイル（探索結果で特定されたファイルを活用）
    4. 実装ステップ（具体的に）
    5. 注意点・リスク

    ## タスク分割（重要）
    タスク管理ツール（TaskCreate/TaskUpdate）が利用可能な場合は、
    実装ステップをタスクとして登録し、依存関係（blockedBy）を設定すること。
    - 1タスク = 1つの明確な成果物（1-2ファイル程度）
    - blockedBy で前提タスクを指定
    - 並列可能なタスクは依存関係なし

    ## 利用可能なツール
    - Read: ファイル読み込み
    - Glob: ファイル検索
    - Grep: コード検索
    - TaskCreate: タスク登録（利用可能な場合）
    - TaskUpdate: 依存関係設定（利用可能な場合）
```

### Step 4: Planner 完了待ち

```
1. TaskOutput で planner の結果を取得
2. `.orchestrator/plan.md` を読み込む
3. 計画をユーザーに提示し、Phase 2 に進む
```

### Step 5: Phase 2 - タスクごとにtask-managerを起動

Orchestrator が依存グラフに基づいてtask-managerを起動する。
task-manager が内部で Implementer → Code Reviewer → 完了判定を管理する。

**実装ループ（Orchestrator が実行）:**

```
while (pendingタスクが残っている):

  1. TaskList でブロック解除済み（blockedByが空）の pending タスクを取得

  2. 各タスクに対して task-manager をバックグラウンド起動
     ※ 独立したタスクは並列起動する

     Task tool:
       description: "task-manager: {タスク件名}"
       subagent_type: general-purpose
       model: sonnet
       run_in_background: true
       prompt: |
         あなたはtask-managerエージェントです。
         以下のタスクのライフサイクルを管理してください。

         ## 担当タスク
         - タスクID: {taskId}
         - 件名: {subject}
         - 説明: {description}
         - 完了条件: {completionCriteria}

         ## コードレビュー
         {有効 / 無効}

         ## 手順
         1. Implementer をサブエージェントとして起動し、実装を委譲
         2. コードレビューが有効なら Code Reviewer を起動
         3. 結果を基に completed / rejected を判定
         4. rejected の場合は Implementer を再起動（最大2回）

  3. TaskOutput で全 task-manager の完了を待つ

  4. TaskList で新たにブロック解除されたタスクを確認
     → pending タスクがあれば 1 に戻る
```

### Step 6: Phase 2 完了・報告

1. TaskList で全タスクが completed であることを確認
2. 各 task-manager の結果を統合して `.orchestrator/implementation-log.md` に書き出す
3. 実装結果をユーザーに報告
4. **ここで自動実行を停止**

### Step 7: 次のステップの案内

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
