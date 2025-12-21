# 実装計画から GitHub Issues を作成

Keywords: github-issues, epic, sub-issues, automation, implementation-plan, mcp-prompts, mcp-tools

## 目的

実装計画ドキュメント (`implementation-plan-template.md`) から、Epic および子 Issue を自動生成し、GitHub Issues として起票します。

## 使用する MCP ツール

このコマンドは以下の MCP ツールを使用します：

- **`get_implementation_plan_to_issues`**: Issue 作成ガイドライン (`implementation-plan-to-issues.md`) を取得する専用ツール

## 使用する MCP リソース

以下の MCP prompts も併せて使用できます：

- `implementation-plan-template`: 実装計画のテンプレート構造
- `epic-template`: Epic Issue のテンプレート
- `feature-template`: Feature Issue のテンプレート
- `migration-template`: Migration Issue のテンプレート
- `test-template`: Test Issue のテンプレート
- `docs-template`: Docs Issue のテンプレート
- `chore-template`: Chore Issue のテンプレート

## 前提条件

- `gh` CLI がインストール済み・認証済み
- リポジトリのラベルが設定済み（例: `type:feature`, `type:migration`, `type:test`, `type:docs`, `priority:P1|P2|P3`, `size:S|M|L`）
- **MCP サーバーが起動済み**: 以下のテンプレートを MCP prompts から取得します
  - `implementation-plan-template`: 実装計画テンプレート
  - `epic-template`: Epic Issue テンプレート
  - `feature-template`: Feature Issue テンプレート
  - `migration-template`: Migration Issue テンプレート
  - `test-template`: Test Issue テンプレート
  - `docs-template`: Docs Issue テンプレート
  - `chore-template`: Chore Issue テンプレート
- 実装計画ドキュメントが存在（またはユーザーが提供）

## 処理フロー

1. **MCP から必要なドキュメントを取得**

   - **実装計画テンプレート**: MCP prompts から `implementation-plan-template` を読み込み
   - **Issue テンプレート**: MCP prompts から各種テンプレートを読み込み
     - `epic-template` (Epic 用)
     - `feature-template` (実装 Issue 用)
     - `migration-template` (移行 Issue 用)
     - `test-template` (テスト Issue 用)
     - `docs-template` (ドキュメント Issue 用)
     - `chore-template` (Chore Issue 用)
   - ユーザーから実装計画ファイルのパスを受け取る場合はそれを使用

2. **実装計画の解析**

   - 機能名、設計方針、コンポーネント、移行計画を抽出
   - Epic および子 Issue のリストを生成

3. **Epic Issue の作成**

   - MCP から取得した `epic-template` をベースに Epic を作成
   - タイトル: `[Feature] <機能名>: 実装計画と進行管理`
   - サブ Issue のチェックリストを含む

4. **子 Issue の作成候補を提示**

   - 実装 Issue（コンポーネント/ユーティリティ）
   - 移行 Issue（Phase 1〜4）
   - 品質 Issue（テスト/パフォーマンス/セキュリティ/ドキュメント）

5. **GitHub Issues として作成**
   - `gh issue create` コマンドを使用
   - ラベル、マイルストーンを適切に設定

## Prompt Template

以下のタスクを実行してください：

1. **MCP ツール「get_implementation_plan_to_issues」を利用して、Issue 作成ガイドラインを読み込むこと**

2. **MCP prompts から必要なテンプレートを読み込むこと**

   - `implementation-plan-template`: 実装計画の構造を理解
   - `epic-template`, `feature-template`, `migration-template`, `test-template`, `docs-template`, `chore-template`: 各種 Issue テンプレート

3. **実装計画ドキュメントを解析すること**

   - ユーザーが指定した実装計画ファイル（または `implementation-plan-template`）を読み込み
   - 機能名、設計方針、コンポーネント、移行計画を抽出

4. **Epic Issue と子 Issue のドラフトを生成すること**

   - Epic: 全体の進行管理用
   - Feature: 実装タスク（コンポーネント/ユーティリティ）
   - Migration: 移行フェーズ（Phase 1〜4）
   - Quality: テスト/パフォーマンス/セキュリティ/ドキュメント

5. **GitHub Issues を作成すること**
   - `gh issue create` コマンドを使用
   - 適切なラベル、マイルストーン、優先度を設定

## 使用方法

### 基本的な使い方

```
@workspace 実装計画から GitHub Issues を作成してください
```

### 実装計画ファイルを指定する場合

```
@workspace <ファイルパス> の実装計画から GitHub Issues を作成してください
```

### オプション指定

```
@workspace 実装計画から GitHub Issues を作成してください
- マイルストーン: Sprint 5
- 優先度: P2
- 担当者: @username
```

## 実行手順

1. **MCP からテンプレートを取得**

   - MCP prompts から `implementation-plan-template` を取得し、実装計画の構造を理解
   - MCP prompts から各種 Issue テンプレート (`epic-template`, `feature-template` など) を取得
   - または、ユーザー指定のファイルを読み込み

2. **実装計画の解析と Issue リストの生成**

   - 機能名、コンポーネント、移行計画を抽出
   - MCP から取得したテンプレートを使用して Issue タイトルと本文のドラフトを生成

3. **Epic Issue の作成**

```sh
# Epic 本文を生成
cat > /tmp/epic-body.md <<'EOF'
# 背景 / 目的

- 機能名: <機能名>
- 設計方針の要点（抜粋）: <抽出した設計方針>

# スコープ

- コンポーネント: <抽出したコンポーネント>
- サービス/ユーティリティ: <抽出したサービス>
- 移行フェーズ: Phase1〜4

# サブ Issue（Tasklist）

- [ ] ComponentA: create/parse を実装
- [ ] ComponentA Utils: validate/transform を実装
- [ ] ComponentB: 型/ファクトリを実装
- [ ] Phase 1: 基本実装
- [ ] Phase 2: 既存コード移行
- [ ] Phase 3: テスト/ドキュメント
- [ ] Phase 4: 最適化/クリーンアップ
- [ ] テスト整備
- [ ] パフォーマンス検討
- [ ] セキュリティ/エラー対策
- [ ] ドキュメント更新

# 受け入れ条件（DoD）

- 子 Issue が全て Close
- 相互参照が揃っている
- ドキュメント/テストが最新

# 関連

- 設計ドキュメント: <実装計画ファイルへのリンク>
EOF

# Epic Issue を作成
gh issue create \
  --title "[Feature] <機能名>: 実装計画と進行管理" \
  --body-file /tmp/epic-body.md \
  --label "type:feature" \
  --label "priority:P2"
```

4. **子 Issue 候補の提示**

   - ユーザーに確認を求める
   - 必要に応じて調整

5. **実行確認後、一括作成（オプション）**
   - ユーザーが承認した場合、`gh issue create` を連続実行
   - または、Epic 作成後に UI で「Convert to sub-issues」を使用するよう案内

## Issue 種別とテンプレート

> **注記**: すべてのテンプレートは MCP prompts から取得します。ワークスペースには `general/issue-templates/*.template.md` として保存されていますが、実行時は MCP 経由でアクセスします。

### 実装 Issue（Feature）

MCP Prompt: `feature-template`  
ファイル: `general/issue-templates/feature.template.md`

タイトル例:

- `[Feature][Model] ComponentA: create/parse を実装`
- `[Feature][Util] ComponentA Utils: validate/transform を実装`
- `[Feature][Model] ComponentB: 型とファクトリ実装`

ラベル: `type:feature`, `size:S|M|L`, `area:*`

### 移行 Issue（Migration）

MCP Prompt: `migration-template`  
ファイル: `general/issue-templates/migration.template.md`

タイトル例:

- `[Migration] Phase 1: 基本実装`
- `[Migration] Phase 2: 既存コード移行`
- `[Migration] Phase 3: テストとドキュメント化`
- `[Migration] Phase 4: 最適化とクリーンアップ`

ラベル: `type:migration`, `priority:P1|P2|P3`

### 品質 Issue（Test/Docs/Chore）

MCP Prompts:

- Test: `test-template` (`general/issue-templates/test.template.md`)
- Docs: `docs-template` (`general/issue-templates/docs.template.md`)
- Chore: `chore-template` (`general/issue-templates/chore.template.md`)

タイトル例:

- `[Test] ComponentA/B の単体・結合テスト整備`
- `[Perf] パフォーマンス考慮点の計測/最適化`
- `[Security] エラーハンドリング/入力検証の整備`
- `[Docs] 使用例/設計ドキュメント更新`

ラベル: `type:test`, `type:docs`, `type:chore`

## 実装例（実際の処理）

### ステップ 1: 実装計画の読み込みと解析

```typescript
// 実装計画ドキュメントから情報を抽出
const plan = {
  featureName: "機能名",
  designPrinciples: "設計方針の要点",
  components: ["ComponentA", "ComponentB"],
  phases: ["Phase 1", "Phase 2", "Phase 3", "Phase 4"],
  implementationStatus: {
    done: ["Task 1"],
    todo: ["Task 2", "Task 3"],
  },
};
```

### ステップ 2: Epic Issue の作成

```sh
# Epic Issue 番号を取得
EPIC_NUMBER=$(gh issue create \
  --title "[Feature] ${FEATURE_NAME}: 実装計画と進行管理" \
  --body-file /tmp/epic-body.md \
  --label "type:feature" \
  --label "priority:P2" \
  --json number --jq .number)

echo "Created Epic: #${EPIC_NUMBER}"
```

### ステップ 3: 子 Issue の作成（オプション）

```sh
# ComponentA の実装 Issue
cat > /tmp/component-a-body.md <<EOF
# 目的

- ComponentA の create/parse を実装する

# 仕様

- 入力: <型/前提>
- 出力: <型/結果>

# タスク

- [ ] 型定義の作成/更新
- [ ] create メソッドの実装
- [ ] parse メソッドの実装
- [ ] 単体テスト
- [ ] ドキュメント追加

# 完了条件

- テストがグリーン
- ドキュメントに使用例が掲載

# 関連

- Epic: #${EPIC_NUMBER}
EOF

gh issue create \
  --title "[Feature][Model] ComponentA: create/parse を実装" \
  --body-file /tmp/component-a-body.md \
  --label "type:feature" \
  --label "size:M"
```

## UI での推奨運用（サブ Issue 機能）

Epic を作成後、GitHub UI で以下の操作を行うことを推奨します:

1. Epic Issue を開く
2. 本文のチェックリストにカーソルを合わせる
3. 「Convert to sub-issues」ボタンをクリック
4. 自動で子 Issue が作成され、親子リンクが確立
5. 進捗バーが自動更新される

この方法により、手動で `関連: #<epic>` を記述する必要がなくなります。

## 注意事項

- **MCP サーバー**: MCP prompts から各種テンプレートを取得するため、MCP サーバーが起動している必要があります
  - テンプレートは `general/issue-templates/*.template.md` に保存されていますが、実行時は MCP 経由でアクセスします
  - 利用可能な prompts: `implementation-plan-template`, `epic-template`, `feature-template`, `migration-template`, `test-template`, `docs-template`, `chore-template`
- **ラベル**: リポジトリに存在するラベルのみ指定可能
- **マイルストーン**: 事前に作成しておく必要がある
- **担当者**: GitHub アカウント名で指定（例: `@username`）

## トラブルシューティング

### `gh` CLI が認証されていない

```sh
gh auth login
```

### ラベルが存在しない

```sh
# ラベルを作成
gh label create "type:feature" --color "0E8A16" --description "New feature"
gh label create "type:migration" --color "FBCA04" --description "Migration task"
gh label create "type:test" --color "D93F0B" --description "Testing"
gh label create "type:docs" --color "0075CA" --description "Documentation"
```

または、`scripts/create-github-labels.sh` を実行してください。

### MCP サーバーが起動していない

MCP サーバーの起動状態を確認し、必要に応じて再起動してください。

## 完了チェックリスト

- [ ] MCP ツール `get_implementation_plan_to_issues` で Issue 作成ガイドラインを読み込んだ
- [ ] MCP prompts から必要なテンプレートを読み込んだ
- [ ] 実装計画ドキュメントを解析した
- [ ] Epic Issue が作成された
- [ ] サブ Issue のチェックリストが揃っている
- [ ] ラベル/マイルストーンが適切に設定されている
- [ ] （オプション）子 Issue が作成された、または UI での作成手順が案内された

## Notes

- **MCP Tools**: 実行前に MCP サーバーが起動していることを確認してください
  - `get_implementation_plan_to_issues`: Issue 作成ガイドラインを取得する専用ツール
- **MCP Prompts**: 各種テンプレートは MCP prompts から取得します
- **GitHub CLI**: `gh auth status` で認証状態を確認してください
- **テンプレート**: ワークスペースの `general/issue-templates/` にテンプレートファイルが存在します
- **推奨運用**: Epic 作成後、GitHub UI で「Convert to sub-issues」を使用すると親子リンクが自動設定されます

## 関連ドキュメント

- `general/implementation-plan-template.md`: 実装計画テンプレート
- `general/implementation-plan-to-issues.md`: Issue 作成の詳細ガイド
- `general/issue-templates/*.template.md`: Issue テンプレート集
- `scripts/create-github-labels.sh`: ラベル作成スクリプト
