---
name: pr-all-fix
description: PRのCIエラーとレビュー指摘を一括修正するスキル。CIエラーを先に修正し、次にレビュー指摘を処理する。「PR全部直して」「CIもレビューも直して」などのリクエスト時に使用。
---

# PR問題修正

PRのレビュー指摘事項とCIエラーを1つずつ修正するスキル。

## ワークフロー

```
1. 問題の洗い出し（CI → レビュー指摘の順で優先度判断）
   ↓
2. 問題ごとにTaskCreateでタスク作成（細分化して1タスク=1修正単位）
   ↓
3. タスクをin_progressに更新 → 修正方針を説明 → コード修正 → コミット → 解決済み処理 → タスクをcompletedに更新
   ↓
4. 次のタスクへ（全完了まで繰り返し）
   ↓
5. サマリー報告
```

### タスク管理ルール

- **問題の洗い出し後、修正に着手する前に全タスクを作成する**
- タスクは細かく分ける（例: 「テスト失敗3件」→ テストケースごとに3タスク）
- CIエラーとレビュー指摘はカテゴリを分けてタスク化
- タスクの`subject`には具体的な修正対象を書く（例: `CIエラー修正 - UserService.tsの型エラー`）
- `activeForm`を必ず設定する（例: `UserService.tsの型エラーを修正中`）
- 修正開始時: `TaskUpdate`で`status: "in_progress"`に更新
- 修正＆コミット完了後: レビュー指摘の場合は解決済み処理を実行してから`TaskUpdate`で`status: "completed"`に更新
- 全タスク完了後にサマリーを報告

## 対象

### CIエラー
- ビルドエラー
- テスト失敗
- Lint/型エラー

### レビュー指摘
- 未解決（unresolved）のコメントのみ対象
- resolved済みはスキップ

## 修正ルール

### 必須
- **1問題 = 1タスク = 1コミット**（まとめて修正しない）
- 修正前に問題内容と方針を説明
- コミットメッセージに修正対象を明記
- **修正完了後は必ずTaskUpdateでタスクをcompletedにする**
- **レビュー指摘の修正＆コミット後は、該当スレッドを解決済みにする**（後述の「解決済み処理」参照）

### 優先順位
1. CIエラー（先に直すとレビュー対応がスムーズになることが多い）
2. レビュー指摘事項

## 解決済み処理

レビュー指摘を修正＆コミットした後、該当のレビュースレッドを解決済み（resolved）にする。

### 手順

1. **問題の洗い出し時にスレッドIDを記録する**
   - `gh api graphql` でPRのレビュースレッド一覧を取得し、未解決スレッドのIDとコメント内容を紐づけて記録する
   ```bash
   gh api graphql -f query='
     query($owner: String!, $repo: String!, $pr: Int!) {
       repository(owner: $owner, name: $repo) {
         pullRequest(number: $pr) {
           reviewThreads(first: 100) {
             nodes {
               id
               isResolved
               comments(first: 1) {
                 nodes {
                   body
                   path
                   line
                 }
               }
             }
           }
         }
       }
     }' -f owner='{owner}' -f repo='{repo}' -F pr={pr_number}
   ```

2. **修正＆コミット後にスレッドを解決済みにする**
   ```bash
   gh api graphql -f query='
     mutation($threadId: ID!) {
       resolveReviewThread(input: {threadId: $threadId}) {
         thread {
           isResolved
         }
       }
     }' -f threadId='{thread_id}'
   ```

3. **CIエラーはスレッド解決の対象外**（レビュー指摘のみ）

## コミット形式

```
🐛 [Bug fix]: CIエラー修正 - {エラー内容}
```

```
♻️ [Refactoring]: レビュー指摘対応 - {指摘内容}
```

## 完了時の報告

```
## 修正サマリー

### CIエラー
- [x] {エラー1} → {対応内容}
- [x] {エラー2} → {対応内容}

### レビュー指摘
- [x] {指摘1} → {対応内容}
- [x] {指摘2} → {対応内容}
```
