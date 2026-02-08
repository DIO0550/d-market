---
name: setup-statusline
description: Powerlineスタイルのステータスラインをセットアップする。「ステータスライン設定」「statusline setup」「ステータスバー」などのリクエスト時に使用。
---

# ステータスライン セットアップ

Powerlineスタイルの2行ステータスラインをプロジェクトに設定するスキル。

## 前提条件

- **Nerd Font** がターミナルにインストールされていること（Powerlineセパレータ `\uE0B0` とブランチアイコン `\uE0A0` を使用）
- **jq** がインストールされていること

## セットアップ手順

以下の手順を **順番に** 実行してください。

### 1. スクリプトに実行権限を付与

```bash
chmod +x <project_root>/plugins/statusline-plugin/scripts/statusline.sh
```

`<project_root>` は現在のプロジェクトルートの絶対パスに置き換えてください。

### 2. 設定ファイルを更新

Claude Code の設定ファイルには優先度があります。**必ず最優先のファイルに設定してください。**

| ファイル | 優先度 |
|---------|--------|
| `.claude/settings.local.json` | **最高**（存在する場合はこちらを更新） |
| `.claude/settings.json` | 中 |
| `~/.claude/settings.json` | 低 |

**手順:**

1. まず `.claude/settings.local.json` が存在するか確認する
2. 存在する場合は `.claude/settings.local.json` を更新する
3. 存在しない場合は `.claude/settings.json` を更新する

更新対象のファイルを読み込み、`statusLine` フィールドを追加または更新してください。

設定内容:

```json
{
  "statusLine": {
    "type": "command",
    "command": "<project_root>/plugins/statusline-plugin/scripts/statusline.sh"
  }
}
```

- ファイルが存在しない場合は新規作成
- 既存のフィールドがある場合はそれを保持し、`statusLine` のみ追加/上書き
- `<project_root>` は絶対パスに置き換え

> **注意:** `settings.local.json` に古い `statusLine` 設定が残っていると、`settings.json` を更新しても反映されません。

### 3. 完了メッセージ

セットアップ完了後、以下を伝えてください:

- ステータスラインが設定されたこと
- Claude Code を **再起動** すると反映されること
- Nerd Font 対応ターミナルが必要なこと

## カラーテーマ

**Blue + Orange accent** を採用（256色モード）。

| セグメント | 256色コード | 色 | 表示内容 |
|-----------|------------|-----|---------|
| 1番目 | 24 | 濃いブルー | パス / モデル名 |
| 2番目 | 31 | 明るいブルー | ブランチ / セッション時間 |
| 3番目 | 172 | ソフトオレンジ | 変更行数 / コンテキスト使用率 |
| 文字色 | 255 | 白 | 全セグメント共通 |

## 表示内容

```
 …/work/d-market  main  (+0,-0)
 Opus 4.6  Block: 0hr 23m  Ctx: 0.0%
```

| 行 | セグメント1 | セグメント2 | セグメント3 |
|----|-----------|-----------|-----------|
| 1行目 | 作業パス（短縮） | Git ブランチ | 変更行数 (+追加,-削除) |
| 2行目 | モデル名 | セッション経過時間 | コンテキスト使用率 |
