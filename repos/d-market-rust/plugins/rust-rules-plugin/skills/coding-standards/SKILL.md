---
name: coding-standards
description: Rust基本実装ルール。所有権、エラーハンドリング、命名規則、不変性などのコーディング規約を定義。実装時に参照すべき基本ルールを提供する。
---

# Rust基本実装ルール

Rust開発における基本的なコーディング規約を定義するスキル。

## 基本方針

- 早期returnでネストを浅くする
- `clippy` の警告をすべて解消する
- `rustfmt` でフォーマットを統一
- マジックナンバーは使用せず定数を定義

## 一般原則

- **単一責任の原則**: 関数・モジュールは「1つのこと」に集中
- **所有権を意識**: 必要最小限の借用、可能な限り参照を使用
- **不変性を優先**: `let` を基本、`mut` は必要な場合のみ
- **明示的なインターフェース**: `pub` は最小限に
- **命名は意図を表現**: 略語・あいまい語を避け、ドメイン語彙を使用

## 所有権と借用

```rust
// ✅ 参照を優先
fn process(data: &str) -> String { ... }

// ❌ 不必要な所有権の移動
fn process(data: String) -> String { ... }

// ✅ 変更が必要な場合のみ可変参照
fn update(data: &mut Vec<i32>) { ... }
```

## エラーハンドリング

```rust
// ✅ Result型を使用
fn parse_config(path: &str) -> Result<Config, ConfigError> { ... }

// ✅ ?演算子で伝播
fn load_data() -> Result<Data, Error> {
    let config = parse_config("config.toml")?;
    let data = fetch_data(&config)?;
    Ok(data)
}

// ❌ unwrap/expectの乱用
let value = result.unwrap(); // パニックの可能性

// ✅ 適切なエラー処理
let value = result.map_err(|e| CustomError::from(e))?;
```

## 型定義

```rust
// ✅ 型エイリアスで意図を明確に
type UserId = u64;
type Result<T> = std::result::Result<T, AppError>;

// ✅ newtypeパターンで型安全性
struct Email(String);
struct Password(String);
```

## 命名規則

| 種類 | 規則 | 例 |
|:-|:-|:-|
| 構造体・列挙型・トレイト | PascalCase | `UserAccount`, `ParseError` |
| 関数・変数・モジュール | snake_case | `parse_config`, `user_name` |
| 定数 | SCREAMING_SNAKE_CASE | `MAX_CONNECTIONS` |
| ライフタイム | 短い小文字 | `'a`, `'de` |

## Option/Resultの扱い

```rust
// ✅ コンビネータを活用
let name = user.name.as_ref().map(|n| n.to_uppercase());

// ✅ if letで簡潔に
if let Some(value) = optional {
    process(value);
}

// ✅ matchで網羅的に
match result {
    Ok(value) => handle_success(value),
    Err(e) => handle_error(e),
}
```

## コメントルール

- **docコメント**: `///` で公開APIにはdocコメントを記載
- **実装の意図**: 特別な理由で実装している箇所はコメントを記載
- **その他**: 上記以外はコメントを記載しない

## モジュール構成

```rust
// ✅ mod.rsまたはファイル名でモジュール定義
// src/
//   lib.rs
//   config/
//     mod.rs
//     parser.rs

// ✅ 公開範囲を最小限に
pub(crate) fn internal_helper() { ... }
pub fn public_api() { ... }
```

## 禁止事項

- `unsafe` の不必要な使用
- `clone()` の乱用（パフォーマンス低下）
- `unwrap()` / `expect()` の本番コードでの使用
- `#[allow(...)]` によるclippy警告の無効化
