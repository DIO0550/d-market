# Exploration Perspectives（探索の4観点）

各カテゴリで何を調べるべきかの具体的チェックリストと推奨検索パターン。

---

## 1. アーキテクチャ概要

### チェック項目

- [ ] ディレクトリ構造: `src/`, `lib/`, `components/` 等の配置
- [ ] 設定ファイル: package.json, tsconfig.json, Cargo.toml, pyproject.toml
- [ ] README / ARCHITECTURE: プロジェクト概要、アーキテクチャドキュメント
- [ ] レイヤー分割: Presentation, Application, Infrastructure の分離
- [ ] モジュール構成: フィーチャー分割 vs レイヤー分割
- [ ] 依存関係: import/export の流れ、循環依存の有無
- [ ] 外部ライブラリ: 主要な依存とバージョン

### 推奨パターン

```yaml
Glob:
  - "src/**/*.{ts,tsx,rs,py}"   # ソースファイル全体像
  - "**/package.json"            # npm パッケージ
  - "**/Cargo.toml"              # Rust クレート
  - "**/tsconfig*.json"          # TypeScript 設定

Grep:
  - pattern: "^import.*from"
    output_mode: files_with_matches
    type: ts
  - pattern: "^export.*(function|const|class|interface|type)"
    output_mode: files_with_matches
    type: ts
  - pattern: "^use "
    output_mode: files_with_matches
    type: rust
```

---

## 2. 関連コード分析

### チェック項目

- [ ] 類似コンポーネント: 同じパターンで実装されている機能
- [ ] 共通ユーティリティ: utils/, helpers/, lib/ 配下の再利用可能コード
- [ ] デザインパターン: Factory, Builder, Strategy 等の使用例
- [ ] 状態管理: Redux, Zustand, Context API 等の実装パターン
- [ ] API 呼び出し: fetch, axios, GraphQL client の使い方
- [ ] エラーハンドリング: try-catch, Result 型のパターン
- [ ] 命名規則: ファイル名、変数名、関数名の一貫性

### 推奨パターン

```yaml
Grep:
  # 類似機能の検索（{keyword} を対象機能のキーワードに置換）
  - pattern: "{keyword}"
    output_mode: content
    context: 3

  # ユーティリティ関数
  - pattern: "export (function|const)"
    output_mode: content
    context: 3
    glob: "**/utils/**"

  # 型定義
  - pattern: "^(export )?(interface|type) "
    output_mode: content
    context: 5
    type: ts
```

---

## 3. 技術的制約・リスク

### チェック項目

- [ ] 型システム制約: strict モード、型定義の厳格度
- [ ] リンター設定: ESLint, Clippy, Pylint のルール
- [ ] フォーマッター: Prettier, rustfmt, Black の設定
- [ ] ビルド設定: Webpack, Vite, cargo build の最適化
- [ ] 環境変数: .env ファイル、環境依存の設定
- [ ] ライブラリバージョン: deprecated API、breaking changes
- [ ] パフォーマンス: 既知のボトルネック、大量データ処理
- [ ] セキュリティ: 認証、認可、入力検証

### 推奨パターン

```yaml
Read:
  - tsconfig.json        # TypeScript 設定
  - .eslintrc*            # ESLint 設定
  - .prettierrc*          # Prettier 設定
  - Cargo.toml            # Rust 依存・設定
  - .env.example          # 環境変数テンプレート

Grep:
  - pattern: "@deprecated"
    output_mode: content
    context: 3
  - pattern: "TODO|FIXME|HACK|XXX"
    output_mode: content
    context: 2
  - pattern: "process\\.env|std::env"
    output_mode: files_with_matches
```

---

## 4. 変更影響範囲

### チェック項目

- [ ] 依存の逆引き: 変更対象を import しているファイル
- [ ] テストファイル: 関連するユニットテスト、統合テスト
- [ ] Public API: export されている関数・クラス・型
- [ ] CI/CD 設定: .github/workflows/, .gitlab-ci.yml
- [ ] ドキュメント: README, CHANGELOG への影響

### 推奨パターン

```yaml
Glob:
  - "**/*.test.{ts,tsx,js,jsx}"  # Jest / Vitest テスト
  - "**/*.spec.{ts,tsx,rs}"      # spec テスト
  - "**/__tests__/**"             # テストディレクトリ
  - ".github/workflows/*.yml"    # CI 設定

Grep:
  # 逆引き検索（{target} を変更対象ファイル名に置換）
  - pattern: "import.*from.*{target}"
    output_mode: files_with_matches
  - pattern: "require\\(.*{target}"
    output_mode: files_with_matches

  # Public API
  - pattern: "^export (function|const|class|interface|type)"
    output_mode: content
    context: 3
```

---

## 探索のコツ

1. **広く浅く → 深く狭く**: 最初は Glob でファイル全体像を把握し、関連性の高い部分を Grep + Read で深掘り
2. **head_limit の活用**: 大量ヒットする場合は `head_limit: 30` 等で絞る
3. **コンテキスト付き**: コードスニペットは `context: 3-5` で前後を含めて読む
4. **並列実行**: 独立した Glob/Grep は並列で実行して効率化
5. **指示書優先**: CLAUDE.md の検索ルール・除外パターンに必ず従う
