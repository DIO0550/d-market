---
name: storybook
description: Storybook Storyファイルルール。CSF3.0形式、Meta/StoryObj型定義、Args活用、Story種類（Default/AllProps/EdgeCases）などの規約を定義。Storyファイル作成時に参照。
---

# Storybook Storyファイルルール

Storybook Storyファイル作成における規約を定義するスキル。

## 基本ルール

- **ファイル名**: `ComponentName.stories.tsx`
- **デフォルトエクスポート**: Metaオブジェクトをデフォルトエクスポート
- **Story定義**: 名前付きエクスポートで各ストーリーを定義
- **型定義**: `Meta<typeof Component>` と `StoryObj<typeof Component>` を使用
- **Args活用**: propsはargsとして定義し再利用可能に
- **関数型Args**: イベントハンドラーは `fn()` を使用
- **Title設定**: Metaに title は設定しない（ファイルパスから自動生成）
- **CSF3.0**: Component Story Format 3.0 の記法を使用

## Story種類

| Story | 内容 |
|:-|:-|
| Default | 最も基本的な使用例 |
| AllProps | すべてのpropsを設定した状態 |
| EdgeCases | 境界値や特殊な状態 |
| Interactive | ユーザーインタラクション（必要に応じて） |

## 基本例

```tsx
import type { Meta, StoryObj } from "@storybook/react";
import { fn } from "@storybook/test";
import { Button } from "./Button";

const meta: Meta<typeof Button> = {
  component: Button,
  args: {
    onClick: fn(),
  },
};
export default meta;

type Story = StoryObj<typeof Button>;

export const Default: Story = {
  args: {
    label: "Click me",
  },
};

export const AllProps: Story = {
  args: {
    label: "Submit",
    variant: "primary",
    disabled: false,
  },
};
```

## 推奨事項

- **ドキュメント**: コンポーネントの使用方法を説明するdocsを記述
- **Play関数**: 複雑なインタラクションはplay関数で自動化
- **Decorator**: 共通のラッパーやスタイルはdecoratorsで適用
- **Parameters**: ストーリー固有の設定はparametersで定義

## 禁止事項

- Story内でビジネスロジックを実装しない
- API呼び出しや外部サービスへの直接的な依存を避ける
- 類似Story間でのコード重複を避ける
