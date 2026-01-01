# Spec-Driven Development

## Description

機能実装前に対話的なヒアリングで仕様を明確化し、implementation-plan.mdとtasks.mdを生成します。Codexによる自動レビューで品質を担保します。

## Prompt Template

`spec-driven-dev`スキルを使用して、仕様駆動型開発を実行してください。

以下のタスクを実行してください：

1. **ヒアリング実施**

   **Batch 1: スコープ確認**
   - 何を実現したいか（目的）
   - 影響範囲（新規 / 既存修正）
   - 優先度・緊急度

   **Batch 2: 技術的詳細**
   - 使用技術・フレームワーク
   - 依存関係
   - データ構造・API設計

   **Batch 3: 品質要件**
   - エッジケース・エラーハンドリング
   - テスト要件
   - パフォーマンス要件

2. **implementation-plan.md 生成**

   - `.specs/{feature-name}/implementation-plan.md` に出力
   - ファイル単位で `[NEW]` `[MODIFY]` `[DELETE]` タグを使用
   - 検証計画を必ず含める

3. **Codexレビューループ**

   ```bash
   codex -q "以下の実装計画をレビューしてください。

   レビュー観点:
   1. 仕様の曖昧さ・抜け漏れはないか
   2. 実装可能性に問題はないか
   3. エッジケースは考慮されているか
   4. ファイル構成は妥当か
   5. 全体アーキテクチャとの整合性はあるか

   問題がなければ「問題なし」と回答してください。
   問題があれば具体的な指摘と改善案を提示してください。
   "
   ```

   - 「問題なし」になるまで修正→レビューを繰り返す（最大5回）

4. **tasks.md 生成**

   - `.specs/{feature-name}/tasks.md` に出力
   - Research & Planning / Implementation / Verification の3構成

5. **ユーザー確認**

   - implementation-plan.md のサマリー提示
   - tasks.md のタスク一覧提示
   - 修正要求があればStep 3に戻る

## Notes

- AskUserQuestionツールを使って対話的にヒアリングする
- 一度に聞く質問は1-4個に抑える
- 1機能 = 1計画（小さく保つ）
- 質問形式は `references/question-patterns.md` を参照
- レビュー観点は `references/review-criteria.md` を参照
