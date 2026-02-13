# Spec-Driven Development (Lite)

## Description

機能実装前に対話的なヒアリングで仕様を明確化し、探索と計画をサブエージェントに委譲して implementation-plan.md と tasks.md を生成します。他のAIによるレビューを省略した軽量版です。

## Prompt Template

`spec-driven-dev-lite`スキルを使用して、仕様駆動型開発を実行してください。

以下のタスクを実行してください：

0. **PLANNINGファイル配置**（ヒアリング開始前に必ず実行）

   - specsフォルダと PLANNINGファイルを作成する
   - `.specs/{nnn}-{feature-name}/PLANNING` ファイルが存在する間は**計画フェーズ**
   - **PLANNINGファイルがある限り、絶対にコードを実装しない**

   ```bash
   next_num=$(printf "%03d" $(( $(ls -1d .specs/[0-9][0-9][0-9]-* .specs/archive/[0-9][0-9][0-9]-* 2>/dev/null | sed 's|.*/\([0-9]\{3\}\)-.*|\1|' | sort -rn | head -1 | sed 's/^0*//; s/^$/0/') + 1 )))
   mkdir -p .specs/${next_num}-{feature-name} && touch .specs/${next_num}-{feature-name}/PLANNING
   ```

1. **ヒアリング実施 → hearing-notes.md 書き出し**

   AskUserQuestion でヒアリングし、結果を `.specs/{nnn}-{feature-name}/hearing-notes.md` に書き出す。

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

2. **コードベース探索（codebase-explorer サブエージェントに委譲）**

   - hearing-notes.md を元に codebase-explorer サブエージェントを Task tool で起動
   - 4カテゴリ（アーキテクチャ・関連コード・技術的制約・変更影響範囲）を探索
   - `.specs/{nnn}-{feature-name}/exploration-report.md` に結果を出力
   - `TaskOutput` で完了待ち

3. **実装計画生成（spec-planner サブエージェントに委譲）**

   - hearing-notes.md + exploration-report.md を元に spec-planner サブエージェントを起動
   - `.specs/{nnn}-{feature-name}/implementation-plan.md` + `tasks.md` を生成
   - **⚠️ システム図（状態マシン図 + データフロー図）は必須 — 省略禁止**
   - `TaskOutput` で完了待ち

4. **ユーザー確認**

   - implementation-plan.md のサマリー提示
   - tasks.md のタスク一覧提示
   - 修正要求があればStep 3に戻る

5. **PLANNINGファイル削除**（実装開始許可後）

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
- **他のAI（Codex/Copilot）によるレビューは省略**
- 探索と計画はサブエージェントに委譲する
