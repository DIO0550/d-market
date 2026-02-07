# Spec-Driven Development

## Description

機能実装前に対話的なヒアリングで仕様を明確化し、implementation-plan.mdとtasks.mdを生成します。Codexによる自動レビューで品質を担保します。

## Prompt Template

`spec-driven-dev`スキルを使用して、仕様駆動型開発を実行してください。

以下のタスクを実行してください：

0. **PLANNINGファイル配置**（ヒアリング開始前に必ず実行）

   - specsフォルダと PLANNINGファイルを作成する
   - `.specs/{nnn}-{feature-name}/PLANNING` ファイルが存在する間は**計画フェーズ**
   - **PLANNINGファイルがある限り、絶対にコードを実装しない**

   ```bash
   next_num=$(printf "%03d" $(( $(ls -1d .specs/[0-9][0-9][0-9]-* .specs/archive/[0-9][0-9][0-9]-* 2>/dev/null | sed 's|.*/\([0-9]\{3\}\)-.*|\1|' | sort -rn | head -1 | sed 's/^0*//; s/^$/0/') + 1 )))
   mkdir -p .specs/${next_num}-{feature-name} && touch .specs/${next_num}-{feature-name}/PLANNING
   ```

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

   - `.specs/{nnn}-{feature-name}/implementation-plan.md` に出力
   - ファイル単位で `[NEW]` `[MODIFY]` `[DELETE]` タグを使用
   - 検証計画を必ず含める
   - **⚠️ システム図を最初に生成する**（状態マシン図 + データフロー図 — 省略禁止）
     - 図を先に作り、その後で変更案・検証計画を書く
     - 図がない場合、implementation-plan.mdは不完全として扱う

3. **Codexレビューループ**

   ```bash
   codex exec --dangerously-bypass-approvals-and-sandbox "以下の実装計画をレビューしてください。

   【重要】ファイルの作成・編集は一切行わないでください。レビュー結果は標準出力のみで回答してください。

   レビュー対象: .specs/{nnn}-{feature-name}/implementation-plan.md

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

   - `.specs/{nnn}-{feature-name}/tasks.md` に出力
   - Research & Planning / Implementation / Verification の3構成

5. **ユーザー確認**

   - implementation-plan.md のサマリー提示
   - tasks.md のタスク一覧提示
   - 修正要求があればStep 3に戻る

6. **PLANNINGファイル削除**（実装開始許可後）

   - ユーザーから実装開始の許可を得たら PLANNINGファイルを削除
   - **PLANNINGファイル削除前に実装コードを書いてはならない**

   ```bash
   rm .specs/{nnn}-{feature-name}/PLANNING
   ```

## Notes

- AskUserQuestionツールを使って対話的にヒアリングする
- 一度に聞く質問は1-4個に抑える
- 1機能 = 1計画（小さく保つ）
- 質問形式は `references/question-patterns.md` を参照
- レビュー観点は `references/review-criteria.md` を参照
