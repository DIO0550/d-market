---
name: component
description: Reactコンポーネントルール。関数コンポーネント、Props定義、単一責任、命名規則、アクセシビリティ、条件付きレンダリングなどの規約を定義。コンポーネント実装時に参照。
---

# Reactコンポーネントルール

Reactコンポーネント実装における規約を定義するスキル。

## 基本ルール

- 関数コンポーネントを使用する
  - `React.FC` は使用せず、`JSX.Element` を返す関数として定義
  - 再描画コストが高い場合は `React.memo` を使用
- Propsは同ファイル内で `type Props` として定義
- 単一責任の原則に従い、1コンポーネント = 1責任
- ビジネスロジックはcustom hooksに抽出して再利用

## 命名規則

- コンポーネント名: `PascalCase`
- props/変数名: `camelCase`

## Props設計

- デフォルトpropsが必要な場合は関数のデフォルト引数で定義

```tsx
type Props = {
  title: string;
  count?: number;
};

export const MyComponent = ({ title, count = 0 }: Props): JSX.Element => {
  return <div>{title}: {count}</div>;
};
```

## 条件付きレンダリング

- 論理演算子（`&&`）よりも三項演算子を優先
- ネストが深くなる場合は別コンポーネントに切り出す

```tsx
// ✅ 推奨
{isLoading ? <Spinner /> : <Content />}

// ❌ 非推奨（falsy値の問題）
{count && <Badge count={count} />}
```

## リスト要素

- `key` propを適切に設定
- インデックスは避ける（安定したIDを使用）

## アクセシビリティ

- aria属性を適切に設定
- セマンティックHTMLを使用
- キーボード操作を考慮

## Storybook

- 同ファイルに `.stories.tsx` を作成
- 見た目の確認はStorybookで行う
- 動作の確認はVitestで行う

## 関連スキル

- コメント: `coding-standards`
- テスト: `testing`
- カスタムフック: `custom-hook`
