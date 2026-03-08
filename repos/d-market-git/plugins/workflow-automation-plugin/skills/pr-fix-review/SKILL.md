---
name: pr-fix-review
description: PRのレビュー指摘修正スキル。未解決のレビューコメントを確認し、1つずつ順番に修正してコミットし、スレッドを解決済みにする。「レビュー指摘を直して」「レビュー対応して」などのリクエスト時に使用。
---

# レビュー指摘修正

PRのレビュー指摘を1つずつ修正するスキル。

## ワークフロー

```
1. レビュー指摘の洗い出し（未解決スレッドのみ取得、スレッドIDを記録）
   ↓
2. 指摘ごとにTaskCreateでタスク作成（細分化して1タスク=1修正単位）
   ↓
3. タスクをin_progressに更新 → 修正方針を説明 → コード修正 → コミット → 解決済み処理 → タスクをcompletedに更新
   ↓
4. 次のタスクへ（全完了まで繰り返し）
   ↓
5. サマリー報告
```

### タスク管理ルール

- **指摘の洗い出し後、修正に着手する前に全タスクを作成する**
- タスクは細かく分ける（1指摘 = 1タスク）
- タスクの`subject`には具体的な修正対象を書く（例: `レビュー指摘対応 - UserService.tsのエラーハンドリング`）
- `activeForm`を必ず設定する（例: `UserService.tsのエラーハンドリングを修正中`）
- 修正開始時: `TaskUpdate`で`status: "in_progress"`に更新
- 修正＆コミット完了後: 解決済み処理を実行してから`TaskUpdate`で`status: "completed"`に更新
- 全タスク完了後にサマリーを報告

## 対象

- 未解決（unresolved）のレビューコメントのみ
- resolved済みはスキップ

## 修正ルール

### 必須
- **1指摘 = 1タスク = 1コミット**（まとめて修正しない）
- 修正前に指摘内容と方針を説明
- コミットメッセージに修正対象を明記
- **修正完了後は必ずTaskUpdateでタスクをcompletedにする**
- **修正＆コミット後は、該当スレッドを解決済みにする**（後述の「解決済み処理」参照）

## 解決済み処理

レビュー指摘を修正＆コミットした後、該当のレビュースレッドを解決済み（resolved）にする。

### 手順

1. **指摘の洗い出し時にスレッドIDを記録する**
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

## コミット形式

```
♻️ [Refactoring]: レビュー指摘対応 - {指摘内容}
```

## 完了時の報告

```
## レビュー指摘修正サマリー

- [x] {指摘1} → {対応内容} (resolved)
- [x] {指摘2} → {対応内容} (resolved)
- [x] {指摘3} → {対応内容} (resolved)
```
