---
name: api-spec
description: API仕様書作成スキル。Markdown形式のAPI仕様書、OpenAPI(YAML)定義、GraphQLスキーマ定義を対話的に生成する。REST API、GraphQL APIのエンドポイント、リクエスト/レスポンス、認証、エラーハンドリングを網羅。「API仕様書を書きたい」「OpenAPIを作りたい」「GraphQLスキーマを定義したい」「エンドポイント設計をまとめたい」「REST APIの仕様を整理したい」「swagger定義を作りたい」などのリクエスト時に使用。
---

# API Spec - API Specification Generator

API仕様書を対話的に作成するスキル。3つの出力フォーマットに対応。

## Output Formats

| Format | Template | Use Case |
|:-------|:---------|:---------|
| Markdown | `assets/templates/api-spec.md` | Human-readable API documentation |
| OpenAPI | `assets/templates/openapi.yaml` | Machine-readable REST API definition (OpenAPI 3.1) |
| GraphQL | `assets/templates/graphql-schema.md` | GraphQL schema definition with documentation |

## Workflow

```
1. Determine output format
   ↓
2. Hearing (batched questions via AskUserQuestion)
   ↓
3. Generate spec from template
   ↓
4. Present to user for review
   ↓
5. Revise if requested → Write final document
```

## Step 1: Determine Format

Detect from user's request:
- "API仕様書" / "API doc" / "REST API" → **Markdown**
- "OpenAPI" / "Swagger" / "YAML定義" → **OpenAPI**
- "GraphQL" / "スキーマ定義" / "schema" → **GraphQL**
- Ambiguous → Ask with AskUserQuestion

Multiple formats can be generated from a single hearing session if requested.

## Step 2: Hearing

Read `references/hearing-patterns.md` and follow the batched hearing flow.

Rules:
- 1-4 questions per batch using AskUserQuestion
- Skip questions the user already answered
- Match the user's language
- For OpenAPI: focus on precise request/response schemas
- For GraphQL: focus on types, queries, mutations, subscriptions

## Step 3: Generate Document

1. Read the template from `assets/templates/`
2. Fill in sections based on hearing results
3. Adapt sections (see `references/hearing-patterns.md` Section Adaptation Rules)
4. Format-specific rules:
   - **Markdown**: Mermaid sequence diagrams for data flow, tables for endpoints
   - **OpenAPI**: Valid YAML conforming to OpenAPI 3.1 spec, `$ref` for reusable schemas
   - **GraphQL**: SDL syntax, include descriptions as doc comments, resolver notes in separate section

## Step 4: Present & Revise

1. Show brief summary of generated spec
2. Ask if revisions are needed
3. Apply changes if requested → present again
4. If approved → write to file

## Step 5: Write Output

**Default output directory**: `docs/`
**Custom output**: If user specifies a path, use that instead.

File naming:
- `docs/api-spec-{name}.md`
- `docs/openapi-{name}.yaml`
- `docs/graphql-schema-{name}.md`
