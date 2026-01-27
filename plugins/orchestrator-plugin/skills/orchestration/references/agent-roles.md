# エージェント役割定義

各エージェントの役割、責務、使用ツール、入出力を定義する。

## エージェント一覧

| エージェント | 役割 | 使用ツール | 起動タイミング |
|-------------|------|-----------|---------------|
| **planner** | タスク分析・実装計画作成 | Read, Glob, Grep | 最初に起動 |
| **explorer** | ファイル探索・コード調査 | Glob, Grep, Read | 計画時に並列起動 |
| **implementer** | コード実装 | Read, Write, Edit | 計画完了後 |
| **test-runner** | テスト実行・結果報告 | Bash | 実装後 |
| **linter** | Lint実行・修正提案 | Bash | 実装後（テストと並列可） |
| **committer** | コミット作成 | Bash (git) | テスト・Lint成功後 |
| **pr-creator** | PR作成 | Bash (gh) | コミット後 |

---

## planner エージェント

### 役割
ユーザーのタスクを分析し、具体的な実装計画を作成する。

### 入力
- ユーザーのタスク説明

### 出力
- `.orchestrator/plan.md` に実装計画を書き出す

### 計画に含める内容
1. **タスクの理解**: 何を達成しようとしているか
2. **目的**: なぜこの変更が必要か
3. **変更の概要**: 大まかに何を変更するか
4. **変更対象ファイル**: どのファイルを変更するか（推測含む）
5. **実装ステップ**: 具体的な実装手順
6. **注意点・リスク**: 考慮すべき点

### 使用ツール
- Read: 既存コードの確認
- Glob: ファイル構造の把握
- Grep: 関連コードの検索

---

## explorer エージェント

### 役割
タスクに関連するファイルや既存実装パターンを探索する。

### 入力
- ユーザーのタスク説明

### 出力
- `.orchestrator/exploration.md` に探索結果を書き出す

### 探索する内容
1. **関連する既存コード**: 変更対象や参考になるコード
2. **類似の実装パターン**: 既存の類似機能の実装方法
3. **設定ファイル**: 影響を受ける設定
4. **テストファイル**: 既存のテストや追加すべきテスト
5. **ドキュメント**: 関連するドキュメント

### 使用ツール
- Glob: ファイルパターン検索
- Grep: コンテンツ検索
- Read: ファイル内容確認

---

## implementer エージェント

### 役割
計画に基づいてコードを実装する。

### 入力
- `.orchestrator/plan.md`: 実装計画
- `.orchestrator/exploration.md`: 探索結果

### 出力
- コードファイルの編集/作成
- `.orchestrator/implementation-log.md` に実装ログを書き出す

### 実装時の注意点
1. 既存のコードスタイルに従う
2. 最小限の変更で目的を達成する
3. 必要に応じてテストコードも追加
4. 変更内容を実装ログに記録

### 使用ツール
- Read: ファイル読み込み
- Write: 新規ファイル作成
- Edit: 既存ファイル編集

---

## test-runner エージェント

### 役割
テストを実行し、結果を報告する。

### 入力
- プロジェクトタイプ（自動検出）

### 出力
- `.orchestrator/test-results.md` にテスト結果を書き出す

### コマンド自動検出
| プロジェクト | コマンド |
|-------------|---------|
| Node.js (package.json) | `npm test` |
| Rust (Cargo.toml) | `cargo test` |
| Python (pyproject.toml) | `pytest` |
| Go (go.mod) | `go test ./...` |

### 使用ツール
- Bash: テストコマンド実行
- Glob: プロジェクトタイプ検出
- Read: 設定ファイル確認

---

## linter エージェント

### 役割
Lintを実行し、結果を報告する。

### 入力
- プロジェクトタイプ（自動検出）

### 出力
- `.orchestrator/lint-results.md` にLint結果を書き出す

### コマンド自動検出
| プロジェクト | コマンド |
|-------------|---------|
| Node.js (package.json) | `npm run lint` |
| Rust (Cargo.toml) | `cargo clippy` |
| Python (pyproject.toml) | `ruff check .` |
| Go (go.mod) | `golangci-lint run` |

### 使用ツール
- Bash: Lintコマンド実行
- Glob: プロジェクトタイプ検出
- Read: 設定ファイル確認

---

## committer エージェント

### 役割
変更をGitにコミットする。

### 入力
- `.orchestrator/implementation-log.md`: 実装内容の確認
- git status: 変更ファイルの確認

### 出力
- Gitコミットの作成

### コミットメッセージ
- 変更内容を簡潔に説明
- 必要に応じてConventional Commits形式を使用
- Co-authored-by を追加

### 使用ツール
- Bash: git コマンド実行
- Read: 実装ログ確認

---

## pr-creator エージェント

### 役割
Pull Requestを作成する。

### 入力
- `.orchestrator/plan.md`: 計画（PRの説明に使用）
- `.orchestrator/implementation-log.md`: 実装内容
- git log: コミット履歴

### 出力
- GitHub Pull Request の作成

### PRの内容
- タイトル: 変更内容を簡潔に
- 本文:
  - Summary: 変更の概要
  - Test plan: テスト方法
  - 生成者表示

### 使用ツール
- Bash: gh コマンド実行
- Read: 計画・実装ログ確認
