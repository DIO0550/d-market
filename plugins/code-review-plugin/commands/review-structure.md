# Review Structure

## Description

コード構造の改善可能箇所を特定し、Guard Clauses、Dead Code削除、対称性の統一などの観点から改善提案を行うコマンドです。

## Prompt Template

`structure-reviewer`エージェントを使用して、コード構造をレビューしてください。

以下のタスクを実行してください：

1. **スキルの参照ファイルを使用してレビュー基準を取得する**

   - `code-review-skill:structure-review` を取得し、レビュー基準を確認

2. **優先度: 高の観点でチェックする**

   - Guard Clauses: 早期リターンでネストを浅くできるか
   - Dead Code Removal: 未使用コードはないか
   - Normalize Symmetries: 対称性が統一されているか
   - Extract Helper: 共通処理を抽出できるか
   - 型定義の明確化: any型が使われていないか

3. **優先度: 中の観点でチェックする**

   - Reading Order: 読みやすい順序になっているか
   - Cohesion Order: 関連コードがまとまっているか
   - Explicit Parameters: 暗黙のパラメータがないか
   - Chunk Statements: 関連文がグループ化されているか

4. **改善提案を提供する**
   - 現在のコードと改善後のコード例を提示
   - 優先度別に分類して報告
   - 各改善の理由を簡潔に説明

## Notes

- 動作を変更する改善は提案しない
- 各改善は小規模で安全なものに限定
- 既存のコードスタイルとプロジェクトの慣習を尊重
- すでに適切に構造化されている場合はその旨を報告
- レビュー結果は日本語で提供
