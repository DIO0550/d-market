---
name: implementation-workflow
description: Rustプロジェクトで実装を開始する際に必ず参照するスキル。新機能追加、バグ修正、リファクタリングなどコードを変更するすべての作業で使用する。TDDによるRed-Green-Refactorサイクル、cargo fmt/clippy/testによる品質チェック、ブランチ運用ルールを定義。「Rustで実装」「Rustコードを書く」「機能を追加」「バグを修正」などのリクエスト時に自動参照。
---

# Rust実装ワークフロー

Rust開発における実装フローのエントリーポイント。状況に応じて適切なスキルを参照する。

## 関連スキル参照ガイド

| 状況 | 参照スキル |
|:-|:-|
| コーディング中 | `coding-standards` |
| テスト作成時 | `tdd`, `testing` |
| コミット時 | `commit`（git-workflow-plugin） |
| PR作成時 | `pull-request`（git-workflow-plugin） |

## 実装フロー

### 1. 作業開始

```bash
# mainで作業しない！必ず新ブランチを作成
git checkout -b feature/機能名
```

### 2. 実装計画を提示

コード変更前に以下を提示し承認を得る：
- タスクの理解と分析
- 実装すべき機能・モジュールの概要
- ファイル構成と変更対象
- 実装手順とステップ

### 3. TDDで実装

→ 詳細は `tdd` スキルを参照

- Red → Green → Refactor のサイクル
- 先にテストを書いてから実装

### 4. コーディング規約に従う

→ 詳細は `coding-standards` スキルを参照

- 所有権と借用の適切な使用
- エラーハンドリング
- 命名規則

### 5. 品質チェック（必須）

```bash
cargo fmt          # フォーマット
cargo clippy       # Lintチェック
cargo test         # テスト実行
```

**全て通るまでコミット禁止**

### 6. コミット

→ 詳細は `commit` スキルを参照

## 禁止事項

- `unsafe` の不必要な使用
- clippy警告の無視（`#[allow(...)]` 禁止）
- mainブランチで直接作業禁止
- `unwrap()` / `expect()` の本番コードでの使用

## ブランチ命名規則

| プレフィックス | 用途 |
|:-|:-|
| `feature/` | 新機能追加 |
| `fix/` | バグ修正 |
| `refactor/` | リファクタリング |
| `docs/` | ドキュメント更新 |

## チェックリスト

```
## 実装前
- [ ] 新ブランチを作成した
- [ ] 実装計画を提示し承認を得た

## 実装中
- [ ] TDDサイクルを守っている（tddスキル参照）
- [ ] コーディング規約に従っている（coding-standardsスキル参照）

## 実装後
- [ ] `cargo fmt` 実行済み
- [ ] `cargo clippy` 警告なし
- [ ] `cargo test` 通過
- [ ] コミットルールに従っている（commitスキル参照）
```
