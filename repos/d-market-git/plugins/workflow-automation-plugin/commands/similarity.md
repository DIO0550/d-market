# similarity command

## Description

similarity-ts コマンドを利用して、重複しているコードを共通化して下さい。

## Prompt Template

以下のタスクを実行してください：

- `similarity-ts . --threshold 0.8 --min-lines 10` でコードの意味的な類似が得られます。あなたはこれを実行し、ソースコードの重複を検知して、リファクタリング計画を立てます。細かいオプションは similarity-ts -h で確認してください。
