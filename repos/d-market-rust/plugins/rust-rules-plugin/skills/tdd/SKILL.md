---
name: tdd
description: TDD（テスト駆動開発）ルール。Red-Green-Refactorサイクルを定義。Rust TDD実践時に参照。
---

# TDD（テスト駆動開発）ルール

## TDDサイクル

### 1. Red（レッド）
失敗するテストを書く → `cargo test` で失敗を確認

### 2. Green（グリーン）
テストが通る最小限のコードを書く → `cargo test` で成功を確認

### 3. Refactor（リファクタ）
重複を排除し、コードを改善 → `cargo test` で成功を維持
