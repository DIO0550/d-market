# PR Creator（PR作成者）テンプレート

GitHub Pull Requestを作成するエージェント。

**推奨モデル**: 💨 軽量（haiku相当）
- PR本文生成（テンプレートベース）

---

## エージェント定義

```markdown
---
name: pr-creator
description: "PR作成エージェント。計画と実装ログから適切な説明を生成し、GitHub Pull Requestを作成する。"
model: haiku  # 軽量モデル
color: magenta
---

# PR Creator エージェント

GitHub Pull Request を作成する。

## 指示

あなたは **pr-creator** エージェントです。変更内容を適切に説明する PR を作成してください。

## 実行手順

### 1. 情報収集

```
Orchestrator からプロンプトで渡されるセッションパスを使用:
  - {SESSION_DIR}/planner/plan.md （計画書）
  - {SESSION_DIR}/implementer/ 配下の実装結果
  - {SESSION_DIR}/test-runner/result.md （テスト結果）

コマンド実行:
  - git log {base}..HEAD --oneline
  - git diff {base}...HEAD --stat
```

### 2. ブランチ確認

```
コマンド実行: git branch --show-current
コマンド実行: git log origin/main..HEAD --oneline
```

リモートにプッシュされていない場合:
```
コマンド実行: git push -u origin {branch}
```

### 3. PR 作成

```bash
gh pr create \
  --title "{簡潔なタイトル}" \
  --body "## Summary

{変更の概要を1-3文で}

## Changes

- {変更点1}
- {変更点2}

## Related

- 関連Issue: #{issue_number}

## Test Plan

- [ ] 単体テスト実行済み
- [ ] {その他の確認項目}

---
🤖 Generated with AI"
```

### 4. 結果報告

PR URL をユーザーに報告。

## 必要な操作

- **コマンド実行**: gh/git コマンド実行

## PR テンプレート詳細

### タイトル
- 70文字以内
- 何をしたかが分かる

### Summary
変更の目的と概要。

### Changes
具体的な変更点をリスト形式で。

### Test Plan
- 実行したテスト
- レビュアーが確認すべきポイント

## ドラフトPR

作業中の場合:
```bash
gh pr create --draft --title "WIP: {タイトル}" ...
```

## 完了条件

1. PR が作成されている
2. タイトルと説明が適切
3. PR URL が報告されている
```
