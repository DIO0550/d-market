---
name: spec-driven-dev
description: 仕様駆動型開発スキル。機能実装前に対話的なヒアリングで仕様を明確化し、implementation-plan.mdとtasks.mdを生成する。「機能を実装したい」「新しいコンポーネントを作りたい」「○○を追加したい」などの実装リクエスト時に使用。Codexによる自動レビューと修正ループで品質を担保する。
---

# Spec-Driven Development

機能実装前に仕様を明確化し、実装計画とタスクリストを生成するスキル。

## ワークフロー概要

```
1. ユーザーが目的を伝える
   ↓
2. AskUserQuestion形式でヒアリング
   ↓
3. implementation-plan.md 生成
   ↓
4. Codexレビュー → 修正ループ（自動）
   ↓
5. tasks.md 生成
   ↓
6. ユーザーに提示
```

## Step 1: ヒアリング

ユーザーの要求を受けたら、以下の観点で質問する。一度に1-4個の質問をまとめて聞く。

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

## Step 2: implementation-plan.md 生成

ヒアリング結果を元に `.specs/{feature-name}/implementation-plan.md` を生成。

テンプレート: `assets/templates/implementation-plan.md`

### 生成時の注意点

- 1機能 = 1計画（小さく保つ）
- ファイル単位で変更内容を明記
- `[NEW]` `[MODIFY]` `[DELETE]` タグを使用
- 検証計画を必ず含める

## Step 3: Codexレビューループ

生成した implementation-plan.md を Codex でレビューする。

### レビュー実行

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

---
$(cat .specs/{feature-name}/implementation-plan.md)
"
```

### ループ処理

1. Codexの出力を解析
2. 「問題なし」なら Step 4 へ
3. 問題があれば:
   - 指摘内容を元に implementation-plan.md を修正
   - 再度 Codex レビューを実行
   - 最大5回までループ

レビュー観点の詳細は `references/review-criteria.md` を参照。

## Step 4: tasks.md 生成

レビュー完了後、`.specs/{feature-name}/tasks.md` を生成。

テンプレート: `assets/templates/tasks.md`

### タスク構成

```
Task: {目的}

□ Research & Planning
  □ サブタスク1
  □ サブタスク2

□ Implementation  
  □ サブタスク1
  □ サブタスク2

□ Verification
  □ サブタスク1
  □ サブタスク2
```

## Step 5: ユーザー確認

生成したファイルをユーザーに提示:

1. implementation-plan.md の内容サマリー
2. tasks.md のタスク一覧
3. 「修正が必要な場合はお知らせください」

ユーザーが修正を要求した場合は Step 3 のループに戻る。

## 出力ディレクトリ

```
.specs/
└── {feature-name}/
    ├── implementation-plan.md
    └── tasks.md
```

`{feature-name}` はケバブケースで命名（例: `user-authentication`, `block-button`）
