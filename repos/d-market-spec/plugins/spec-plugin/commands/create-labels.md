# Create Labels

## Description

GitHub リポジトリに仕様策定・Issue管理用のラベルを一括作成します。

## Prompt Template

`plan-to-issues`スキルのスクリプトを使用して、ラベルを作成してください。

以下のタスクを実行してください：

1. **現在のラベル確認**

   ```bash
   gh label list
   ```

2. **ラベル作成スクリプト実行**

   ```bash
   # ドライラン（確認のみ）
   DRY_RUN=1 ./plugins/spec-plugin/skills/plan-to-issues/scripts/create-github-labels.sh

   # 実行
   ./plugins/spec-plugin/skills/plan-to-issues/scripts/create-github-labels.sh
   ```

3. **作成されるラベル**

   | カテゴリ | ラベル |
   |:-|:-|
   | 種別 | `type:epic`, `type:feature`, `type:migration`, `type:chore`, `type:test`, `type:docs` |
   | 領域 | `area:frontend`, `area:server`, `area:shared` |
   | 優先度 | `priority:P1`, `priority:P2`, `priority:P3` |
   | 規模 | `size:S`, `size:M`, `size:L` |

## Notes

- 既存ラベルはスキップされる（上書きしない）
- 上書き更新したい場合は `FORCE_UPDATE=1` を指定
- 特定リポジトリに作成する場合は `REPO=owner/repo` を指定
