---
name: markdown-spec
description: Markdown形式の仕様書作成スキル。機能仕様書、API仕様書、システム設計書を対話的なヒアリングを通じて構造化されたMarkdownドキュメントとして生成する。Mermaid図やテーブル定義を含む。「仕様書を書きたい」「APIの仕様をまとめたい」「システム設計をドキュメント化したい」「機能の仕様書を作成したい」「specを書きたい」などのリクエスト時に使用。
---

# Markdown Spec - Specification Document Generator

Markdown形式の仕様書を対話的に作成するスキル。

## Supported Spec Types

| Type | Template | Use Case |
|:-----|:---------|:---------|
| Feature Spec | `assets/templates/feature-spec.md` | User stories, screen/UI, business rules |
| API Spec | `assets/templates/api-spec.md` | Endpoints, request/response, auth |
| System Design | `assets/templates/system-design.md` | Architecture, components, infrastructure |

## Workflow

```
1. Determine spec type (auto-detect or ask user)
   ↓
2. Hearing (batched questions via AskUserQuestion)
   ↓
3. Generate spec document from template
   ↓
4. Present to user for review
   ↓
5. Revise if requested
   ↓
6. Write final document to output directory
```

## Step 1: Determine Spec Type

Detect spec type from user's request keywords. See `references/hearing-patterns.md` for detection rules.

If ambiguous, ask with AskUserQuestion:

```
Question: "Which type of specification do you want to create?"
Options:
- Feature Spec: User stories, screens, business rules
- API Spec: Endpoints, request/response, authentication
- System Design: Architecture, components, infrastructure
```

## Step 2: Hearing

Read `references/hearing-patterns.md` and follow the batched hearing flow for the selected spec type.

Rules:
- Ask 1-4 questions per batch using AskUserQuestion
- Start with Batch 1 (common basics), then spec-type-specific batches
- If the user already provided sufficient information, skip redundant questions
- Match the user's language (Japanese input → Japanese spec, English input → English spec)

## Step 3: Generate Document

1. Read the template from `assets/templates/{spec-type}.md`
2. Fill in sections based on hearing results
3. Adapt sections: skip irrelevant sections, expand relevant ones (see `references/hearing-patterns.md` Section Adaptation Rules)
4. Include Mermaid diagrams where applicable:
   - **Feature Spec**: State diagram, ER diagram (if data model exists)
   - **API Spec**: Sequence diagram (data flow), ER diagram
   - **System Design**: All diagram types (architecture, sequence, state, ER)
5. Include tables for structured data (requirements, fields, endpoints, etc.)
6. Code examples: include only when relevant (libraries, SDKs, configuration). Omit for business feature specs.

## Step 4: Present & Revise

Present the generated spec to the user:

1. Show a brief summary of what was generated
2. Ask if revisions are needed
3. If revisions requested → apply changes and present again
4. If approved → proceed to write

## Step 5: Write Output

**Default output directory**: `docs/`
**Custom output**: If user specifies a path, use that instead.

File naming: `{spec-type}-{name}.md` in kebab-case.

Examples:
- `docs/feature-spec-user-authentication.md`
- `docs/api-spec-payment-gateway.md`
- `docs/system-design-notification-service.md`

After writing, show the file path to the user.
