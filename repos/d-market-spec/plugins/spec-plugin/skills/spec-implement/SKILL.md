---
name: spec-implement
description: 番号指定で実装を開始するスキル。「/implement 001」のように番号を指定して、該当するspecの実装計画に沿ってタスクを順番に実装する。tasks.mdのチェックリストを更新しながら進め、全タスク完了後にPLANNINGファイルを削除する。
---

# Spec Implement

番号指定で `.specs/{nnn}-{feature-name}/` の実装計画に沿って実装を進めるスキル。

## ワークフロー

```
1. ユーザーが `/implement {nnn}` を実行
   ↓
2. .specs/ から {nnn}-* にマッチするフォルダを特定
   ↓
3. implementation-plan.md を読み込み、変更内容を把握
   ↓
4. tasks.md を読み込み、未完了タスクを確認
   ↓
5. タスクを順番に実装（□のタスクを処理）
   ↓
6. 各タスク完了時に tasks.md を更新（□ → ■）
   ↓
7. 全タスク完了後、PLANNINGファイルを削除
```

## Step 1: specフォルダの特定

引数として受け取った番号（例: `001`）を使い、`.specs/` 配下から `{nnn}-*` にマッチするフォルダを検索する。

```bash
spec_dir=$(ls -1d .specs/${nnn}-* 2>/dev/null | head -1)
```

- マッチするフォルダが見つからない場合はエラーメッセージを表示して終了
- 複数マッチした場合は最初のものを使用

## Step 2: implementation-plan.md の読み込み

`.specs/{nnn}-{feature-name}/implementation-plan.md` を読み込み、以下を把握する：

- 変更対象ファイル（`[NEW]` `[MODIFY]` `[DELETE]`）
- 設計方針
- データ構造・API設計
- 検証計画

## Step 3: tasks.md の読み込み

`.specs/{nnn}-{feature-name}/tasks.md` を読み込み、タスク状態を確認する。

### タスク状態の判定

- `□` — 未完了タスク（実装対象）
- `■` — 完了済みタスク（スキップ）

未完了タスク（`□`）がない場合は「全タスク完了済み」と報告して終了。

## Step 3.5: TaskCreate による進捗管理の初期化

tasks.md の未完了タスク（`□`）をすべて TaskCreate ツールで登録する。

### 登録ルール

- 各 `□` 行に対して TaskCreate を実行
- `subject`: タスク行のテキストをそのまま使用
- `activeForm`: 進行形に変換（例: "型定義を作成" → "型定義を作成中"）
- `description`: implementation-plan.md の該当セクションから補足情報を含める

### 依存関係の設定

TaskUpdate の `addBlockedBy` を使い、以下の順序で依存関係を設定する：

- Research & Planning のタスク → Implementation のタスクが blockedBy で依存
- Implementation のタスク → Verification のタスクが blockedBy で依存
- 同一セクション内で順序依存がある場合も blockedBy を設定
- 独立して実行可能なタスク同士には依存関係を設定しない

## Step 4: タスクの順次実装

未完了タスク（`□`）を上から順番に実装する。

### 各タスクの実装手順

1. TaskUpdate で該当タスクの status を `in_progress` に変更
2. タスク内容を確認
3. implementation-plan.md の該当セクションを参照
4. コードを実装
5. TaskUpdate で該当タスクの status を `completed` に変更
6. tasks.md の該当タスクを更新（`□` → `■`）

### tasks.md の更新

タスク完了時に、該当行の `□` を `■` に変更する。

```
変更前: □ コンポーネントの型定義を作成
変更後: ■ コンポーネントの型定義を作成
```

**重要**: 親タスクは、すべての子タスクが `■` になった時点で `■` に更新する。

## Step 5: PLANNINGファイルの削除

すべてのタスクが完了（`□` が残っていない）したら、PLANNINGファイルを削除する。

```bash
rm .specs/{nnn}-{feature-name}/PLANNING
```

PLANNINGファイルが存在しない場合はスキップする。

## Step 6: 完了報告

実装完了後、ユーザーに以下を報告する：

1. 実装したタスクの一覧
2. 変更したファイルの一覧
3. PLANNINGファイルの削除状態

## 重要な制約

- implementation-plan.md に記載されていない変更は行わない
- tasks.md の順序に従って実装する（スキップしない）
- 各タスク完了ごとに tasks.md を更新する（まとめて更新しない）
- 実装中に問題が発生した場合はユーザーに確認する
- PLANNINGファイルの削除は全タスク完了後のみ
