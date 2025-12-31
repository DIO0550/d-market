# Review TypeScript Test

## Description

TypeScript/Reactプロジェクトのテストコードの品質、構造、網羅性をレビューし、保守性と信頼性の高いテストスイートの構築を支援するコマンドです。

## Prompt Template

`typescript-test-reviewer`エージェントを使用して、テストコードの品質と構造をレビューしてください。

以下のタスクを実行してください：

1. **スキルの参照ファイルを使用してテストレビュー基準を取得する**

   - `typescript-code-review-skill:test-review` を取得し、レビュー基準を確認

2. **品質ゲートチェックを実行する（必須）**

   - 構造違反: `describe`, `context`, `suite` の使用
   - 曖昧なテスト名の検出
   - 共有状態の疑い: `beforeAll`, `afterAll` の使用
   - AAA（Arrange/Act/Assert）パターンの明確性
   - 時間・ランダム依存の固定化

3. **テストコードを多角的に分析する**

   - テスト構造と命名の評価
   - テストの独立性と再現性
   - アサーションの品質
   - モックとスタブの戦略
   - テストの網羅性

4. **品質ゲート結果と改善提案を提供する**
   - PASS/FAIL の判定（Blocking 検出時は FAIL）
   - 問題のある各テストに対して具体的な改善案
   - リファクタリング後のコード例を表示
   - 全体的なテスト戦略の改善提案

## Notes

- **最重要**: `describe`の使用は必ず 🔴 Blocking レベルで報告する
- 完全フラット構造を推奨（テスト名で「対象.メソッド - 条件 - 期待結果」を表現）
- FIRST 原則（Fast, Independent, Repeatable, Self-Validating, Timely）に基づく評価
- テストフレームワーク（Jest, Pytest, JUnit 等）に応じた適切な評価
- Blocking が 1 つでもあれば必ず FAIL として報告
- レビュー結果は日本語で提供
