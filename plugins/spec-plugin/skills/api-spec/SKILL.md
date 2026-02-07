---
name: api-spec
description: API仕様書作成スキル。Markdown形式のAPI仕様書、OpenAPI(YAML)定義、GraphQLスキーマ定義を対話的に生成する。REST API、GraphQL APIのエンドポイント、リクエスト/レスポンス、認証、エラーハンドリングを網羅。「API仕様書を書きたい」「OpenAPIを作りたい」「GraphQLスキーマを定義したい」「エンドポイント設計をまとめたい」「REST APIの仕様を整理したい」「swagger定義を作りたい」などのリクエスト時に使用。
---

# API仕様書ジェネレーター

API仕様書を対話的に作成するスキル。3つの出力フォーマットに対応。

## 出力フォーマット

| フォーマット | テンプレート | 用途 |
|:------------|:------------|:-----|
| Markdown | `assets/templates/api-spec.md` | 人が読むためのAPIドキュメント |
| OpenAPI | `assets/templates/openapi.yaml` | 機械可読なREST API定義（OpenAPI 3.1） |
| GraphQL | `assets/templates/graphql-schema.md` | ドキュメント付きGraphQLスキーマ定義 |

## ワークフロー

```
1. 出力フォーマットを判定
   ↓
2. ヒアリング（AskUserQuestionでバッチ質問）
   ↓
3. テンプレートからスペックを生成
   ↓
4. ユーザーに提示してレビュー
   ↓
5. 修正があれば反映 → 最終版を書き出し
```

## Step 1: フォーマット判定

ユーザーのリクエストから検出:
- 「API仕様書」「APIドキュメント」「REST API」 → **Markdown**
- 「OpenAPI」「Swagger」「YAML定義」 → **OpenAPI**
- 「GraphQL」「スキーマ定義」「schema」 → **GraphQL**
- 曖昧な場合 → AskUserQuestion で確認

1回のヒアリングから複数フォーマットを生成することも可能。

## Step 2: ヒアリング

`references/hearing-patterns.md` を読み、バッチ形式のヒアリングフローに従う。

ルール:
- 1回のバッチで1〜4問を AskUserQuestion で質問
- ユーザーが既に回答済みの質問はスキップ
- ユーザーの言語に合わせる
- OpenAPI: リクエスト/レスポンススキーマの正確さを重視
- GraphQL: 型、クエリ、ミューテーション、サブスクリプションを重視

## Step 3: ドキュメント生成

1. `assets/templates/` からテンプレートを読む
2. ヒアリング結果に基づいてセクションを記入
3. セクション適応（`references/hearing-patterns.md` 参照）
4. フォーマット別のルール:
   - **Markdown**: データフローのMermaidシーケンス図、エンドポイントのテーブル
   - **OpenAPI**: OpenAPI 3.1仕様に準拠したYAML、再利用可能なスキーマは `$ref` を使用
   - **GraphQL**: SDL構文、説明はdocコメントとして記載、リゾルバーの補足は別セクション

## Step 4: 提示とレビュー

1. 生成したスペックのサマリーを表示
2. 修正が必要か確認
3. 修正があれば反映 → 再提示
4. 承認されたらファイルに書き出し

## 出力先

**デフォルト出力先**: `docs/`
**カスタム出力**: ユーザーが指定した場合はそのパスを使用。

ファイル名:
- `docs/api-spec-{name}.md`
- `docs/openapi-{name}.yaml`
- `docs/graphql-schema-{name}.md`
