---
name: feature-spec
description: 機能仕様書・PRD（Product Requirements Document）作成スキル。ユーザーストーリー、画面仕様、ビジネスルール、データモデルを含むMarkdown形式の仕様書を対話的に生成する。「機能仕様書を書きたい」「PRDを作りたい」「画面仕様をまとめたい」「ユーザーストーリーを整理したい」「機能の要件定義をしたい」「プロダクト要件を文書化したい」などのリクエスト時に使用。
---

# Feature Spec - Feature Specification & PRD Generator

機能仕様書またはPRD（Product Requirements Document）をMarkdownで対話的に作成するスキル。

## Document Formats

| Format | Template | Use Case |
|:-------|:---------|:---------|
| Feature Spec | `assets/templates/feature-spec.md` | Implementation-oriented: screens, validation, state, data model |
| PRD | `assets/templates/prd.md` | Product-oriented: problem, success metrics, user journey, go-to-market |

## Workflow

```
1. Determine document format (Feature Spec or PRD)
   ↓
2. Hearing (batched questions via AskUserQuestion)
   ↓
3. Generate document from template
   ↓
4. Present to user for review
   ↓
5. Revise if requested → Write final document
```

## Step 1: Determine Format

Detect from user's request:
- "機能仕様書" / "feature spec" / "画面仕様" / "実装仕様" → **Feature Spec**
- "PRD" / "プロダクト要件" / "要件定義書" / "product requirements" → **PRD**
- Ambiguous → Ask with AskUserQuestion

## Step 2: Hearing

Read `references/hearing-patterns.md` and follow the batched hearing flow.

Rules:
- 1-4 questions per batch using AskUserQuestion
- Skip questions the user already answered
- Match the user's language

## Step 3: Generate Document

1. Read the template from `assets/templates/`
2. Fill in sections based on hearing results
3. Adapt sections (see `references/hearing-patterns.md` Section Adaptation Rules):
   - Skip irrelevant sections
   - Expand sections that need more detail
4. Include Mermaid diagrams where applicable (state diagram, ER diagram)
5. Tables for structured data (requirements, fields, rules)
6. **No code examples** unless the feature is a library/SDK/developer tool

## Step 4: Present & Revise

1. Show brief summary of generated document
2. Ask if revisions are needed
3. Apply changes if requested → present again
4. If approved → write to file

## Step 5: Write Output

**Default output directory**: `docs/`
**Custom output**: If user specifies a path, use that instead.

File naming: `{format}-{name}.md` in kebab-case.
- `docs/feature-spec-user-authentication.md`
- `docs/prd-notification-system.md`
