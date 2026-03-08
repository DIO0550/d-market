# d-market

Claude Code用プラグインのマーケットプレイス。

開発ワークフローを効率化するためのプラグイン群を提供します。
用途に合わせて必要なリポジトリだけをインストールできます。

## リポジトリ一覧

### 言語別ツールキット

#### [d-market-rust](https://github.com/DIO0550/d-market-rust)

Rust開発ツールキット（ルール + ワークフロー） — `rust-rules-plugin`, `rust-workflow-plugin`

```sh
claude marketplace install DIO0550/d-market-rust
```

#### [d-market-typescript](https://github.com/DIO0550/d-market-typescript)

TypeScript開発ツールキット（ルール + ワークフロー + レビュー） — `typescript-rules-plugin`, `typescript-workflow-plugin`

```sh
claude marketplace install DIO0550/d-market-typescript
```

#### [d-market-react](https://github.com/DIO0550/d-market-react)

React開発ルール（コンポーネント・フック・Storybook） — `react-rules-plugin`

```sh
claude marketplace install DIO0550/d-market-react
```

### ワークフロー

#### [d-market-orchestrator](https://github.com/DIO0550/d-market-orchestrator)

オーケストレーター（サブエージェント並列起動・タスク分散） — `orchestrator-plugin`

```sh
claude marketplace install DIO0550/d-market-orchestrator
```

#### [d-market-spec](https://github.com/DIO0550/d-market-spec)

仕様策定・実装計画・Issue作成支援 — `spec-plugin`

```sh
claude marketplace install DIO0550/d-market-spec
```

#### [d-market-git](https://github.com/DIO0550/d-market-git)

Git操作支援・PR修正自動化 — `git-workflow-plugin`, `workflow-automation-plugin`

```sh
claude marketplace install DIO0550/d-market-git
```

### コード品質

#### [d-market-code-review](https://github.com/DIO0550/d-market-code-review)

コードレビュー・セキュリティチェック — `code-review-plugin`

```sh
claude marketplace install DIO0550/d-market-code-review
```

#### [d-market-doc-gen](https://github.com/DIO0550/d-market-doc-gen)

仕様書・設計書ドキュメント生成 — `doc-gen-plugin`

```sh
claude marketplace install DIO0550/d-market-doc-gen
```

### ユーティリティ

#### [d-market-file-search](https://github.com/DIO0550/d-market-file-search)

ファイル検索・Web検索エージェント委譲 — `file-search-plugin`

```sh
claude marketplace install DIO0550/d-market-file-search
```

#### [d-market-statusline](https://github.com/DIO0550/d-market-statusline)

Powerlineスタイルのステータスライン — `statusline-plugin`

```sh
claude marketplace install DIO0550/d-market-statusline
```

## 利用シーン別おすすめ

### Rustプロジェクト

- [d-market-rust](https://github.com/DIO0550/d-market-rust) + [d-market-git](https://github.com/DIO0550/d-market-git)

```sh
claude marketplace install DIO0550/d-market-rust
claude marketplace install DIO0550/d-market-git
```

### TypeScript/Reactプロジェクト

- [d-market-typescript](https://github.com/DIO0550/d-market-typescript) + [d-market-react](https://github.com/DIO0550/d-market-react) + [d-market-git](https://github.com/DIO0550/d-market-git)

```sh
claude marketplace install DIO0550/d-market-typescript
claude marketplace install DIO0550/d-market-react
claude marketplace install DIO0550/d-market-git
```

### 大規模機能開発

- [d-market-orchestrator](https://github.com/DIO0550/d-market-orchestrator) + [d-market-spec](https://github.com/DIO0550/d-market-spec)

```sh
claude marketplace install DIO0550/d-market-orchestrator
claude marketplace install DIO0550/d-market-spec
```

### コード品質重視

- [d-market-code-review](https://github.com/DIO0550/d-market-code-review) + [d-market-doc-gen](https://github.com/DIO0550/d-market-doc-gen)

```sh
claude marketplace install DIO0550/d-market-code-review
claude marketplace install DIO0550/d-market-doc-gen
```

## 全プラグイン一括インストール

```sh
claude marketplace install DIO0550/d-market-rust
claude marketplace install DIO0550/d-market-typescript
claude marketplace install DIO0550/d-market-react
claude marketplace install DIO0550/d-market-orchestrator
claude marketplace install DIO0550/d-market-spec
claude marketplace install DIO0550/d-market-git
claude marketplace install DIO0550/d-market-code-review
claude marketplace install DIO0550/d-market-doc-gen
claude marketplace install DIO0550/d-market-file-search
claude marketplace install DIO0550/d-market-statusline
```

## ライセンス

[MIT](./LICENSE)
