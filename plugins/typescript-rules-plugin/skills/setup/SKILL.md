---
name: setup
description: TypeScript/React プロジェクトの指示ファイル（CLAUDE.md、.cursorrules など）に d-market スキル活用ガイドを追加するセットアップスキル。「TypeScriptスキル設定」「TSスキルをCLAUDE.mdに追加」「TypeScriptプラグインセットアップ」などのリクエスト時に使用。
---

# TypeScript ルールスキル セットアップ

プロジェクトの指示ファイルに TypeScript / React 開発ルール系の d-market スキル活用ガイドを追記する。

## 目的

d-market の typescript-rules-plugin をインストール後、プロジェクトの指示ファイルに明示的なスキル利用指示を追加することで、AI が状況に応じてスキルを自動参照するようにする。

## 対象スキル

| スキル | 用途 |
|:--|:--|
| `implementation-workflow` | 実装開始時のエントリーポイント |
| `coding-standards` | TypeScript コーディング規約 |
| `tdd` | TDD Red-Green-Refactor サイクル |
| `testing` | ユニットテスト・統合テストのルール |
| `code-similarity-ts` | コード重複検出 |

### react-rules-plugin がインストール済みの場合

| スキル | 用途 |
|:--|:--|
| `react` | React コンポーネント・カスタムフック・Storybook |

## 実行手順

### 1. 書き込み先の決定

プロジェクトルートで以下のファイルを探し、書き込み先を決定する。

| 優先度 | ファイル | 用途 |
|:--|:--|:--|
| 1 | `CLAUDE.md` | Claude Code |
| 2 | `.cursorrules` | Cursor |
| 3 | `.github/copilot-instructions.md` | GitHub Copilot |
| 4 | その他 | ユーザーが指定したファイル |

複数存在する場合や判断できない場合は、ユーザーに確認する。いずれも存在しない場合は `CLAUDE.md` を新規作成する。

### 2. React 使用有無の検出

`package.json` に `react` 依存がある場合、React セクションを含める。

### 3. 既存セクションの確認

`<!-- d-market:typescript-rules:start -->` 〜 `<!-- d-market:typescript-rules:end -->` マーカーが既に存在する場合は、その範囲を上書き更新する。

### 4. 以下のセクションを生成して追記する

```markdown
<!-- d-market:typescript-rules:start -->
## TypeScript 開発ルール（d-market / typescript-rules-plugin）

TypeScript コードを変更するすべての作業で以下のスキルを参照すること。

- 実装開始時は `implementation-workflow` スキルのフローに従う
- コーディング中は `coding-standards` スキルを参照
- テスト作成時は `tdd` および `testing` スキルを参照
- コード重複が疑われる場合は `code-similarity-ts` スキルを使用
- React コンポーネント実装時は `react` スキルを参照（react-rules-plugin）
<!-- d-market:typescript-rules:end -->
```

**注意**: React を使用していないプロジェクトの場合、React 行は省略する。

### 5. ユーザーへの確認

追記内容と書き込み先をユーザーに提示し、承認を得てから書き込む。

### 6. 完了報告

書き込み完了後、対象ファイルと追加したスキル一覧を報告する。
