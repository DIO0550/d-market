---
name: spec-driven-dev-copilot
description: 仕様駆動型開発スキル（Copilot版）。機能実装前に対話的なヒアリングで仕様を明確化し、探索と計画をサブエージェントに委譲して implementation-plan.md と tasks.md を生成する。「機能を実装したい」「新しいコンポーネントを作りたい」「○○を追加したい」などの実装リクエスト時に使用。GitHub Copilot CLIによる自動レビューと修正ループで品質を担保する。
---

# Spec-Driven Development (Copilot版)

機能実装前に仕様を明確化し、実装計画とタスクリストを生成するスキル。
ヒアリングはオーケストレーターが行い、**探索と計画生成は別々のサブエージェントに委譲**する。

## ⚠️ 重要: システム図は必須

このスキルで生成するimplementation-plan.mdには**必ずシステム図（状態マシン図 + データフロー図）を含めること**。
システム図がないimplementation-plan.mdは不完全であり、生成完了とみなさない。

## ⚠️ 重要: AutoCompact対策

計画フェーズ中にAutoCompactが発生すると、コンテキストが要約され意図しない実装が始まる可能性がある。
これを防ぐため、**PLANNINGファイル**を使用して計画中であることを明示する。

- `.specs/{nnn}-{feature-name}/PLANNING` ファイルが存在する間は**計画フェーズ**
- AutoCompact時にPreCompact hookがPLANNINGファイルを検出し、警告を出力
- **PLANNINGファイルがある限り、絶対にコードを実装しない**

## ワークフロー概要

```
1. specsフォルダ作成 + PLANNINGファイル配置
   ↓
2. AskUserQuestion形式でヒアリング → hearing-notes.md 書き出し
   ↓
3. codebase-explorer サブエージェント → exploration-report.md
   ↓
4. spec-planner サブエージェント → implementation-plan.md + tasks.md
   ↓
5. Copilotレビュー → 修正ループ（自動）
   ↓
6. ユーザーに提示
   ↓
7. 実装開始許可後、PLANNINGファイル削除
```

## Step 1: specsフォルダ + PLANNINGファイル作成

ヒアリング開始前に、specディレクトリとPLANNINGファイルを作成する。

```bash
next_num=$(printf "%03d" $(( $(ls -1d .specs/[0-9][0-9][0-9]-* .specs/archive/[0-9][0-9][0-9]-* 2>/dev/null | sed 's|.*/\([0-9]\{3\}\)-.*|\1|' | sort -rn | head -1 | sed 's/^0*//; s/^$/0/') + 1 )))
mkdir -p .specs/${next_num}-{feature-name} && touch .specs/${next_num}-{feature-name}/PLANNING
```

**重要**: PLANNINGファイルが存在する間は計画フェーズであり、コードの実装は禁止。

## Step 2: ヒアリング → hearing-notes.md 書き出し

ユーザーの要求を受けたら、AskUserQuestion で質問し、結果を `.specs/{nnn}-{feature-name}/hearing-notes.md` に書き出す。

一度に1-4個の質問をまとめて聞く。

### 必須ヒアリング項目

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

質問形式の詳細は `references/question-patterns.md` を参照。

### hearing-notes.md 書き出し

ヒアリング完了後、テンプレートに沿って結果をファイルに書き出す。

テンプレート: `assets/templates/hearing-notes.md`
出力先: `.specs/{nnn}-{feature-name}/hearing-notes.md`

## Step 3: コードベース探索（codebase-explorer サブエージェントに委譲）

hearing-notes.md を書き出したら、codebase-explorer サブエージェントを起動する。

```
Task tool:
  description: "codebase-explorer: {feature-name}"
  subagent_type: general-purpose
  run_in_background: true
  prompt: |
    あなたはcodebase-explorerエージェントです。
    .specs/{nnn}-{feature-name}/hearing-notes.md を読み込み、
    その目的・スコープに基づいてコードベースを探索してください。

    ## 参照スキル
    spec-driven-dev-copilot:exploration-perspectives

    ## テンプレート
    spec-driven-dev-copilot:exploration-report

    ## 出力先
    .specs/{nnn}-{feature-name}/exploration-report.md
```

```
TaskOutput:
  task_id: "{codebase-explorerのtask_id}"
  block: true
  timeout: 300000
```

探索の4カテゴリ: アーキテクチャ概要 / 関連コード分析 / 技術的制約・リスク / 変更影響範囲

詳細は `references/exploration-perspectives.md` を参照。

## Step 4: 実装計画生成（spec-planner サブエージェントに委譲）

exploration-report.md が完成したら、spec-planner サブエージェントを起動する。

```
Task tool:
  description: "spec-planner: {feature-name}"
  subagent_type: general-purpose
  run_in_background: true
  prompt: |
    あなたはspec-plannerエージェントです。
    以下のファイルを読み込み、implementation-plan.md と tasks.md を生成してください。

    ## 入力
    - .specs/{nnn}-{feature-name}/hearing-notes.md
    - .specs/{nnn}-{feature-name}/exploration-report.md

    ## テンプレート
    - spec-driven-dev-copilot:implementation-plan
    - spec-driven-dev-copilot:tasks

    ## 出力先
    - .specs/{nnn}-{feature-name}/implementation-plan.md
    - .specs/{nnn}-{feature-name}/tasks.md

    ## 重要
    - システム図（状態マシン図 + データフロー図）は必須。省略禁止。
    - exploration-report.md の制約・リスクを implementation-plan.md に反映すること。
```

```
TaskOutput:
  task_id: "{spec-plannerのtask_id}"
  block: true
  timeout: 300000
```

## Step 5: Copilotレビューループ

生成した implementation-plan.md を GitHub Copilot CLI でレビューする。

### レビュー実行

```bash
copilot -p "以下の実装計画をレビューしてください。

【重要】ファイルの作成・編集は一切行わないでください。レビュー結果は標準出力のみで回答してください。

レビュー観点:
1. 仕様の曖昧さ・抜け漏れはないか
2. 実装可能性に問題はないか
3. エッジケースは考慮されているか
4. ファイル構成は妥当か
5. 全体アーキテクチャとの整合性はあるか

問題がなければ「問題なし」と回答してください。
問題があれば具体的な指摘と改善案を提示してください。
" .specs/{nnn}-{feature-name}/implementation-plan.md
```

### ループ処理

1. Copilotの出力を解析
2. 「問題なし」なら Step 6 へ
3. 問題があれば:
   - 指摘内容を元に implementation-plan.md を修正
   - 再度 Copilot レビューを実行
   - 最大5回までループ

レビュー観点の詳細は `references/review-criteria.md` を参照。

## Step 6: ユーザー確認

生成したファイルをユーザーに提示:

1. implementation-plan.md の内容サマリー
2. tasks.md のタスク一覧
3. 「修正が必要な場合はお知らせください」

ユーザーが修正を要求した場合は Step 5 のループに戻る。

## Step 7: PLANNINGファイル削除（実装開始）

ユーザーから実装開始の許可を得たら、PLANNINGファイルを削除して実装フェーズに移行する。

```bash
rm .specs/{nnn}-{feature-name}/PLANNING
```

**注意**: PLANNINGファイル削除前に実装コードを書いてはならない。

## 出力ディレクトリ

```
.specs/
└── {nnn}-{feature-name}/
    ├── PLANNING                 # 計画中は存在、実装開始時に削除
    ├── hearing-notes.md         # ヒアリング結果（オーケストレーター生成）
    ├── exploration-report.md    # 探索レポート（codebase-explorer 生成）
    ├── implementation-plan.md   # 実装計画（spec-planner 生成）
    └── tasks.md                 # タスクリスト（spec-planner 生成）
```

`{nnn}` は `.specs/` 内の既存フォルダ数に基づく3桁の連番（001, 002, 003...）
`{feature-name}` はケバブケースで命名（例: `001-user-authentication`, `002-block-button`）
