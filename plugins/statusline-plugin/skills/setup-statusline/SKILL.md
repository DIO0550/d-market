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

### 2. `.claude/settings.json` を更新

プロジェクトルートの `.claude/settings.json` を読み込み、`statusLine` フィールドを追加または更新してください。

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

### 3. 完了メッセージ

セットアップ完了後、以下を伝えてください:

- ステータスラインが設定されたこと
- Claude Code を **再起動** すると反映されること
- Nerd Font 対応ターミナルが必要なこと

## 表示内容

```
 …/work/d-market  main  (+0,-0)
 Opus 4.6  Block: 0hr 23m  Ctx: 0.0%
```

| 行 | セグメント1 | セグメント2 | セグメント3 |
|----|-----------|-----------|-----------|
| 1行目 | 作業パス（短縮） | Git ブランチ | 変更行数 (+追加,-削除) |
| 2行目 | モデル名 | セッション経過時間 | コンテキスト使用率 |
