# d-market

Claude Code用プラグインのマーケットプレイス。

開発ワークフローを効率化するためのプラグイン群を提供します。

## プラグイン一覧

### ワークフロー系

| プラグイン | 説明 | インストール |
|-----------|------|------------|
| [rust-workflow-plugin](./plugins/rust-workflow-plugin) | Rustプロジェクト用ワークフロー（テスト実行・型チェック・ファイル検索） | `claude plugin add DIO0550/d-market --plugin rust-workflow-plugin` |
| [typescript-workflow-plugin](./plugins/typescript-workflow-plugin) | TypeScriptプロジェクト用ワークフロー（テスト実行・型チェック・ファイル検索） | `claude plugin add DIO0550/d-market --plugin typescript-workflow-plugin` |
| [git-workflow-plugin](./plugins/git-workflow-plugin) | Git操作支援（コミット・PR作成・ブランチ保護） | `claude plugin add DIO0550/d-market --plugin git-workflow-plugin` |
| [workflow-automation-plugin](./plugins/workflow-automation-plugin) | ワークフロー自動化（PR修正・CIエラー修正・類似コード検出） | `claude plugin add DIO0550/d-market --plugin workflow-automation-plugin` |
| [orchestrator-plugin](./plugins/orchestrator-plugin) | オーケストレーター（サブエージェント並列起動・タスク分散実行） | `claude plugin add DIO0550/d-market --plugin orchestrator-plugin` |

### コードレビュー系

| プラグイン | 説明 | インストール |
|-----------|------|------------|
| [code-review-plugin](./plugins/code-review-plugin) | コードレビュー・品質チェック（コメント・テスト・命名規則・マジックナンバー・セキュリティ） | `claude plugin add DIO0550/d-market --plugin code-review-plugin` |

### 開発ルール系

| プラグイン | 説明 | インストール |
|-----------|------|------------|
| [react-rules-plugin](./plugins/react-rules-plugin) | React開発ルール（コンポーネント・カスタムフック・Storybook・TDD） | `claude plugin add DIO0550/d-market --plugin react-rules-plugin` |
| [rust-rules-plugin](./plugins/rust-rules-plugin) | Rust開発ルール（実装ワークフロー・TDD・品質チェック・コーディング規約） | `claude plugin add DIO0550/d-market --plugin rust-rules-plugin` |
| [typescript-rules-plugin](./plugins/typescript-rules-plugin) | TypeScript開発ルール（実装ワークフロー・TDD・品質チェック・コーディング規約） | `claude plugin add DIO0550/d-market --plugin typescript-rules-plugin` |

### ドキュメント・仕様系

| プラグイン | 説明 | インストール |
|-----------|------|------------|
| [doc-gen-plugin](./plugins/doc-gen-plugin) | 仕様書・設計書ドキュメント生成（feature-spec・api-spec・system-design） | `claude plugin add DIO0550/d-market --plugin doc-gen-plugin` |
| [spec-plugin](./plugins/spec-plugin) | 仕様策定支援（設計ドキュメント・実装計画・Issue作成・仕様駆動開発） | `claude plugin add DIO0550/d-market --plugin spec-plugin` |

### ユーティリティ系

| プラグイン | 説明 | インストール |
|-----------|------|------------|
| [file-search-plugin](./plugins/file-search-plugin) | ファイル検索のサブエージェント委譲 | `claude plugin add DIO0550/d-market --plugin file-search-plugin` |
| [statusline-plugin](./plugins/statusline-plugin) | Powerlineスタイルのステータスラインセットアップ | `claude plugin add DIO0550/d-market --plugin statusline-plugin` |

## ライセンス

[MIT](./LICENSE)
