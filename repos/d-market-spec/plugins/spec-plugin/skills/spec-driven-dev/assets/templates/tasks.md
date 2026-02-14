# Task: {目的を簡潔に記述}

## Research & Planning

- [ ] {調査・計画タスク1}
- [ ] {調査・計画タスク2}
- [ ] {調査・計画タスク3}

## Implementation

- [ ] {実装タスク1}
- [ ] {実装タスク2}
- [ ] {実装タスク3}
- [ ] {実装タスク4}

## Verification

- [ ] {検証タスク1}
- [ ] {検証タスク2}
- [ ] {検証タスク3}

---

<!--
使用例:

# Task: Implement Block Button on Ranking Page

## Research & Planning

- [ ] Analyze Nico Nico ranking page DOM for User ID and Button placement
- [ ] Explore existing codebase (content scripts, storage)
- [ ] Create Implementation Plan

## Implementation

- [ ] Create/Update content script for Ranking Page
- [ ] Implement generic "Block Button" injection logic
- [ ] Implement logic to extract User ID from DOM
- [ ] Connect button to Blocklist Storage

## Verification

- [ ] Verify button appears on ranking page
- [ ] Verify clicking blocks the user
- [ ] Verify blocked videos are hidden

---

タスク分割のガイドライン:

1. Research & Planning
   - 既存コードの調査
   - DOM/API構造の分析
   - 実装計画の作成
   - 必要なライブラリの調査

2. Implementation
   - 新規ファイルの作成
   - 既存ファイルの修正
   - ロジックの実装
   - UI/スタイリングの実装
   - 連携・統合

3. Verification
   - 機能が動作することの確認
   - エッジケースの確認
   - 既存機能への影響確認
   - パフォーマンス確認（必要時）

各タスクは:
- できるだけ細かい単位に分割する（1ファイル1変更、1関数1タスクが理想）
- 大きなタスクは必ずサブタスクに分解する
- 明確な完了条件がある
- 独立して実行可能（できるだけ）

---

TaskCreate/TaskUpdate 連携ガイドライン:

tasks.md のタスクを実装する際、TaskCreate ツールで進捗管理用のTodoを作成する。

1. タスク作成ルール
   - tasks.md の各タスク行（□）に対して TaskCreate を実行
   - subject: タスク行のテキストをそのまま使用
   - activeForm: 進行形に変換（例: "型定義を作成" → "型定義を作成中"）
   - description: implementation-plan.md の該当セクションから補足情報を含める

2. 依存関係の設定
   - Research & Planning → Implementation → Verification の順序で blockedBy を設定
   - 同一セクション内で順序依存がある場合も blockedBy を設定
   - 独立して実行可能なタスク同士には依存関係を設定しない

3. ステータス更新
   - タスク着手時: TaskUpdate で status を "in_progress" に変更
   - タスク完了時: TaskUpdate で status を "completed" に変更
   - tasks.md の □ → ■ 更新と同時に行う
-->
