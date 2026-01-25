---
name: testing
description: 単体テストルール。モジュール内テスト、モック使用制限、パラメータ化テスト、テストピラミッドなどの規約を定義。Rustテスト実装時に参照。
---

# 単体テストルール

単体テスト実装における規約を定義するスキル。

## 基本ルール

- **網羅テスト**: 正常系・異常系・境界値のテストケースを作成
- **振る舞いのテスト**: 実装詳細ではなく振る舞いを確認
- **モックは最小限**: 基本はモックを使用しない
- **テストケース名**: 意図が明確な命名

## テスト構造

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_login_with_valid_credentials_returns_token() {
        let result = login("test@example.com", "valid_password");
        assert!(result.is_ok());
        assert!(result.unwrap().token.len() > 0);
    }

    #[test]
    fn test_login_with_invalid_email_returns_error() {
        let result = login("invalid", "valid_password");
        assert!(matches!(result, Err(LoginError::InvalidEmail)));
    }
}
```

## テストヘルパー

```rust
#[cfg(test)]
mod tests {
    use super::*;

    // テスト用ヘルパー関数
    fn create_test_user() -> User {
        User {
            id: 1,
            name: "Test User".to_string(),
            email: "test@example.com".to_string(),
        }
    }

    #[test]
    fn test_user_display() {
        let user = create_test_user();
        assert_eq!(user.display_name(), "Test User");
    }
}
```

## パラメータ化テスト

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add_various_inputs() {
        let cases = vec![
            (1, 2, 3),
            (5, 5, 10),
            (-1, 1, 0),
            (0, 0, 0),
        ];

        for (a, b, expected) in cases {
            assert_eq!(add(a, b), expected, "add({}, {}) should be {}", a, b, expected);
        }
    }
}
```

## モックルール

### モック禁止対象
- 自作の関数・モジュール
- プロジェクト内のユーティリティ関数
- 内部状態管理ロジック

### モック許可対象
- HTTPリクエスト
- 外部API呼び出し
- ファイルシステムアクセス
- データベース接続
- 時間依存処理

## テストピラミッド

| レベル | 比率 | 対象 |
|:-|:-|:-|
| 単体テスト | 70-80% | 関数、メソッド、個別モジュール |
| 統合テスト | 15-25% | モジュール間連携、API統合 |
| E2Eテスト | 5-10% | ユーザーシナリオ全体 |

## ディレクトリ構成

```
src/
  lib.rs           # #[cfg(test)] mod tests { ... }
  user/
    mod.rs         # 各モジュール内にテスト
tests/
  integration_test.rs  # 統合テスト
```

## 適正化指針

- **重複テストの排除**: 同じ振る舞いを複数方法でテストしない
- **実装詳細のテスト禁止**: プライベート関数の直接テストは行わない
- **公開インターフェースのみテスト**: 外部から呼び出される関数に集中

## 関連スキル

- TDD: `tdd`
- 実装ワークフロー: `implementation-workflow`
