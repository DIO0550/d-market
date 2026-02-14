# OpenAI Codex CLI AGENTS.md 形式

Codex CLI のエージェント指示ファイル仕様。

## ファイル配置

```
~/.codex/AGENTS.md           # グローバル設定
~/.codex/AGENTS.override.md  # グローバル上書き（優先）
{repo}/AGENTS.md             # リポジトリルート
{repo}/subdir/AGENTS.md      # サブディレクトリ（より具体的）
```

## マージ順序

1. グローバル: `~/.codex/AGENTS.override.md` > `~/.codex/AGENTS.md`
2. プロジェクト: ルートから現在のディレクトリへ向かって連結
3. 後に読み込まれたファイルが優先（上書き）

サイズ上限: `project_doc_max_bytes`（デフォルト 32 KiB）

## ファイル形式

純粋なMarkdown（YAMLフロントマターなし）

```markdown
# AGENTS.md

このリポジトリでの作業指示。

## コーディング規約

- TypeScriptを使用
- 関数には型注釈を付ける
- エラーハンドリングは try-catch で

## テスト

変更を加えたら必ずテストを実行:

```bash
npm test
```

## コミット

- Conventional Commits 形式を使用
- feat: 新機能
- fix: バグ修正

## 禁止事項

- node_modules/ のコミット
- .env ファイルのコミット
- console.log のコミット（デバッグ用除く）
```

## 構造の推奨

```markdown
# AGENTS.md

## プロジェクト概要
簡潔なプロジェクト説明

## セットアップ
開発環境のセットアップ手順

## コーディング規約
コードスタイルのルール

## テスト
テストの実行方法

## コミット
コミットメッセージのルール

## 禁止事項
してはいけないこと
```

## 環境変数

```bash
CODEX_HOME=/custom/path  # デフォルト: ~/.codex
```

設定パラメータ:
- `project_doc_max_bytes`: 最大サイズ（デフォルト 32 KiB）
- `project_doc_fallback_filenames`: 代替ファイル名

## 検証方法

```bash
codex --ask-for-approval never "Summarize current instructions"
```

読み込まれたファイルが優先順位順に表示される。

## オーバーライドパターン

チーム/個人設定の分離:

```
project/
├── AGENTS.md              # チーム共通ルール
└── team-a/
    └── AGENTS.override.md # チームA固有ルール
```

## ベストプラクティス

1. **簡潔に**: 32 KiB 制限を意識
2. **構造化**: 見出しで整理
3. **具体的に**: 曖昧な指示を避ける
4. **実行可能**: コマンド例を含める
5. **階層活用**: 詳細はサブディレクトリへ

## 他ツールとの互換性

AGENTS.md は業界標準として以下でもサポート:
- OpenAI Codex
- GitHub Copilot（読み取り対応）
- Google Jules
- Cursor
- Factory

Linux Foundation の Agentic AI Foundation が管理。
