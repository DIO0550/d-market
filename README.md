# d-market

Claude Code用プラグインのマーケットプレイス。

開発ワークフローを効率化するためのプラグイン群を提供します。
用途に合わせて必要なリポジトリだけをインストールできます。

## リポジトリ一覧

### 言語別ツールキット

| リポジトリ | 説明 | プラグイン | インストール |
|-----------|------|----------|------------|
| [d-market-rust](https://github.com/DIO0550/d-market-rust) | Rust開発ツールキット（ルール + ワークフロー） | rust-rules-plugin, rust-workflow-plugin | `claude mcp add-plugin DIO0550/d-market-rust` |
| [d-market-typescript](https://github.com/DIO0550/d-market-typescript) | TypeScript開発ツールキット（ルール + ワークフロー + レビュー） | typescript-rules-plugin, typescript-workflow-plugin | `claude mcp add-plugin DIO0550/d-market-typescript` |
| [d-market-react](https://github.com/DIO0550/d-market-react) | React開発ルール（コンポーネント・フック・Storybook） | react-rules-plugin | `claude mcp add-plugin DIO0550/d-market-react` |

### ワークフロー

| リポジトリ | 説明 | プラグイン | インストール |
|-----------|------|----------|------------|
| [d-market-orchestrator](https://github.com/DIO0550/d-market-orchestrator) | オーケストレーター（サブエージェント並列起動・タスク分散） | orchestrator-plugin | `claude mcp add-plugin DIO0550/d-market-orchestrator` |
| [d-market-spec](https://github.com/DIO0550/d-market-spec) | 仕様策定・実装計画・Issue作成支援 | spec-plugin | `claude mcp add-plugin DIO0550/d-market-spec` |
| [d-market-git](https://github.com/DIO0550/d-market-git) | Git操作支援・PR修正自動化 | git-workflow-plugin, workflow-automation-plugin | `claude mcp add-plugin DIO0550/d-market-git` |

### コード品質

| リポジトリ | 説明 | プラグイン | インストール |
|-----------|------|----------|------------|
| [d-market-code-review](https://github.com/DIO0550/d-market-code-review) | コードレビュー・セキュリティチェック | code-review-plugin | `claude mcp add-plugin DIO0550/d-market-code-review` |
| [d-market-doc-gen](https://github.com/DIO0550/d-market-doc-gen) | 仕様書・設計書ドキュメント生成 | doc-gen-plugin | `claude mcp add-plugin DIO0550/d-market-doc-gen` |

### ユーティリティ

| リポジトリ | 説明 | プラグイン | インストール |
|-----------|------|----------|------------|
| [d-market-file-search](https://github.com/DIO0550/d-market-file-search) | ファイル検索・Web検索エージェント委譲 | file-search-plugin | `claude mcp add-plugin DIO0550/d-market-file-search` |
| [d-market-statusline](https://github.com/DIO0550/d-market-statusline) | Powerlineスタイルのステータスライン | statusline-plugin | `claude mcp add-plugin DIO0550/d-market-statusline` |

## 利用シーン別おすすめ

### Rustプロジェクト

```sh
claude mcp add-plugin DIO0550/d-market-rust
claude mcp add-plugin DIO0550/d-market-git
```

### TypeScript/Reactプロジェクト

```sh
claude mcp add-plugin DIO0550/d-market-typescript
claude mcp add-plugin DIO0550/d-market-react
claude mcp add-plugin DIO0550/d-market-git
```

### 大規模機能開発

```sh
claude mcp add-plugin DIO0550/d-market-orchestrator
claude mcp add-plugin DIO0550/d-market-spec
```

### コード品質重視

```sh
claude mcp add-plugin DIO0550/d-market-code-review
claude mcp add-plugin DIO0550/d-market-doc-gen
```

## ライセンス

[MIT](./LICENSE)
