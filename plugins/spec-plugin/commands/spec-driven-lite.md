# Spec-Driven Development (Lite)

## Description

機能実装前に対話的なヒアリングで仕様を明確化し、implementation-plan.mdとtasks.mdを生成します。他のAIによるレビューを省略した軽量版です。

## Prompt Template

`spec-driven-dev-lite`スキルを使用して、仕様駆動型開発を実行してください。

以下のタスクを実行してください：

1. **ヒアリング実施**

   **Batch 1: スコープ確認**
   - 何を実現したいか（目的）
   - 影響範囲（新規 / 既存修正）

   **Batch 2: 技術的詳細**
   - 使用技術・フレームワーク
   - 依存関係
   - データ構造・API設計

   **Batch 3: 品質要件**
   - エッジケース・エラーハンドリング
   - テスト要件
   - パフォーマンス要件

2. **implementation-plan.md 生成**

   - `.specs/{nnn}-{feature-name}/implementation-plan.md` に出力
   - ファイル単位で `[NEW]` `[MODIFY]` `[DELETE]` タグを使用
   - 検証計画を必ず含める
   - **⚠️ システム図を最初に生成する**（状態マシン図 + データフロー図 — 省略禁止）
     - 図を先に作り、その後で変更案・検証計画を書く
     - 図がない場合、implementation-plan.mdは不完全として扱う

3. **tasks.md 生成**

   - `.specs/{nnn}-{feature-name}/tasks.md` に出力
   - Research & Planning / Implementation / Verification の3構成

4. **ユーザー確認**

   - implementation-plan.md のサマリー提示
   - tasks.md のタスク一覧提示
   - 修正要求があればStep 2に戻る

## Notes

- AskUserQuestionツールを使って対話的にヒアリングする
- 一度に聞く質問は1-4個に抑える
- 1機能 = 1計画（小さく保つ）
- 質問形式は `references/question-patterns.md` を参照
- **他のAI（Codex/Copilot）によるレビューは省略**
