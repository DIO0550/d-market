---
name: spec-driven-dev
description: 仕様駆動型開発スキル。機能実装前に対話的なヒアリングで仕様を明確化し、implementation-plan.mdとtasks.mdを生成する。「機能を実装したい」「新しいコンポーネントを作りたい」「○○を追加したい」などの実装リクエスト時に使用。Codexによる自動レビューと修正ループで品質を担保する。
---

# Spec-Driven Development

機能実装前に仕様を明確化し、実装計画とタスクリストを生成するスキル。

## ⚠️ 重要: システム図は必須

このスキルで生成するimplementation-plan.mdには**必ずシステム図（状態マシン図 + データフロー図）を含めること**。
システム図がないimplementation-plan.mdは不完全であり、生成完了とみなさない。

## ⚠️ 重要: AutoCompact対策

計画フェーズ中にAutoCompactが発生すると、コンテキストが要約され意図しない実装が始まる可能性がある。
これを防ぐため、**PLANNINGファイル**を使用して計画中であることを明示する。

- `.specs/{feature-name}/PLANNING` ファイルが存在する間は**計画フェーズ**
- AutoCompact時にPreCompact hookがPLANNINGファイルを検出し、警告を出力
- **PLANNINGファイルがある限り、絶対にコードを実装しない**

## ワークフロー概要

```
1. ユーザーが目的を伝える
   ↓
2. specsフォルダ作成 + PLANNINGファイル配置
   ↓
3. AskUserQuestion形式でヒアリング
   ↓
4. implementation-plan.md 生成
   ↓
5. Codexレビュー → 修正ループ（自動）
   ↓
6. tasks.md 生成
   ↓
7. ユーザーに提示
   ↓
8. 実装開始許可後、PLANNINGファイル削除
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

## Step 2: specsフォルダ + PLANNINGファイル作成

ヒアリング開始前または開始直後に、specディレクトリとPLANNINGファイルを作成する。

```bash
mkdir -p .specs/{feature-name} && touch .specs/{feature-name}/PLANNING
```

**重要**: PLANNINGファイルが存在する間は計画フェーズであり、コードの実装は禁止。

## Step 3: implementation-plan.md 生成

ヒアリング結果を元に `.specs/{feature-name}/implementation-plan.md` を生成。

テンプレート: `assets/templates/implementation-plan.md`

### Step 3-1: 各セクションを執筆

- 1機能 = 1計画（小さく保つ）
- ファイル単位で変更内容を明記
- `[NEW]` `[MODIFY]` `[DELETE]` タグを使用
- 検証計画を必ず含める
- **必ずシステム図を含める**（状態マシン図 + データフロー図）

### Step 3-2: システム図を作成

状態マシン図とデータフロー図を**必ず**作成する。これにより：
- すべてのパス・分岐・エッジケースを可視化
- 実装の抜け漏れを防止
- システムレベルでの正しさを検証可能

```
ASCII図の例:

    入力
      │
      ▼
┌─────────────┐
│  STATE_A    │─── 条件1 ───▶ STATE_B
└─────────────┘                  │
      │                          │
   条件2                      条件3
      │                          │
      ▼                          ▼
┌─────────────┐           ┌─────────────┐
│  STATE_C    │           │  STATE_D    │
└─────────────┘           └─────────────┘
```

図に含めるべき要素：
- **状態（State）**: 各状態を明確に命名
- **遷移条件**: 何がトリガーで状態が変わるか
- **分岐**: すべての条件分岐を網羅
- **エッジケース**: エラー時・タイムアウト時の遷移
- **ループ**: 繰り返し処理がある場合

### Step 3-3: 完了チェックリスト

implementation-plan.md生成後、以下を確認すること：

- [ ] 状態マシン図が含まれているか
- [ ] データフロー図が含まれているか
- [ ] 図にすべての状態・遷移条件・エッジケースが含まれているか
- [ ] 図と各セクションの内容が整合しているか

**チェックリストを満たさない場合、生成完了とみなさない。**

## Step 4: Codexレビューループ

生成した implementation-plan.md を Codex でレビューする。

### レビュー実行

```bash
codex exec --full-auto "以下の実装計画をレビューしてください。

レビュー観点:
1. 仕様の曖昧さ・抜け漏れはないか
2. 実装可能性に問題はないか
3. エッジケースは考慮されているか
4. ファイル構成は妥当か
5. 全体アーキテクチャとの整合性はあるか

問題がなければ「問題なし」と回答してください。
問題があれば具体的な指摘と改善案を提示してください。
" .specs/{feature-name}/implementation-plan.md
```

### ループ処理

1. Codexの出力を解析
2. 「問題なし」なら Step 5 へ
3. 問題があれば:
   - 指摘内容を元に implementation-plan.md を修正
   - 再度 Codex レビューを実行
   - 最大5回までループ

レビュー観点の詳細は `references/review-criteria.md` を参照。

## Step 5: tasks.md 生成

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

## Step 6: ユーザー確認

生成したファイルをユーザーに提示:

1. implementation-plan.md の内容サマリー
2. tasks.md のタスク一覧
3. 「修正が必要な場合はお知らせください」

ユーザーが修正を要求した場合は Step 4 のループに戻る。

## Step 7: PLANNINGファイル削除（実装開始）

ユーザーから実装開始の許可を得たら、PLANNINGファイルを削除して実装フェーズに移行する。

```bash
rm .specs/{feature-name}/PLANNING
```

**注意**: PLANNINGファイル削除前に実装コードを書いてはならない。

## 出力ディレクトリ

```
.specs/
└── {feature-name}/
    ├── PLANNING                 # 計画中は存在、実装開始時に削除
    ├── implementation-plan.md
    └── tasks.md
```

`{feature-name}` はケバブケースで命名（例: `user-authentication`, `block-button`）
