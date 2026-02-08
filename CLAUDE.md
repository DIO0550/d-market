# d-market

Claude Code用プラグインのマーケットプレイスリポジトリ。

## リポジトリ構成

```
plugins/
  {plugin-name}/
    plugin.json          # プラグインメタデータ
    agents/              # サブエージェント定義（.md）
    commands/            # コマンド定義（.md）
    skills/              # スキル定義（SKILL.md + references/ + assets/）
    hooks/               # フック定義（hooks.json + スクリプト）
    scripts/             # ユーティリティスクリプト
```

## プラグイン一覧

| プラグイン | 説明 |
|-----------|------|
| code-review-plugin | コードレビュー・品質チェック |
| doc-gen-plugin | 仕様書・設計書ドキュメント生成 |
| file-search-plugin | ファイル検索のサブエージェント委譲 |
| git-workflow-plugin | Git操作支援（コミット・PR・ブランチ保護） |
| orchestrator-plugin | オーケストレーター（サブエージェント並列起動・タスク分散） |
| react-rules-plugin | React開発ルール |
| rust-rules-plugin | Rust開発ルール |
| rust-workflow-plugin | Rustワークフロー（テスト・型チェック・ファイル検索） |
| spec-plugin | 仕様策定・実装計画・Issue作成支援 |
| statusline-plugin | Powerlineスタイルのステータスライン |
| typescript-rules-plugin | TypeScript開発ルール |
| typescript-workflow-plugin | TypeScriptワークフロー（テスト・型チェック・ファイル検索） |
| workflow-automation-plugin | ワークフロー自動化（PR修正・CI修正・類似コード検出） |

## 開発ルール

### コミットメッセージ

`commit-emoji.md` に定義された絵文字フォーマットに従う。

```
絵文字 [タイプ]: メッセージ
```

例: `✨ [New Feature]: ユーザー認証機能を追加`

### プラグイン追加・編集時の注意

- 各プラグインは `plugins/` 配下に独立したディレクトリとして配置
- `plugin.json` は必須（name, version, description, author, repository, license）
- スキルは `skills/{skill-name}/SKILL.md` の形式
- エージェントは `agents/{agent-name}.md` の形式
- コマンドは `commands/{command-name}.md` の形式

### ファイル検索

Markdown（`.md`）やJSON（`.json`）ファイルが中心のため、直接 Glob/Grep で検索して問題ない。
