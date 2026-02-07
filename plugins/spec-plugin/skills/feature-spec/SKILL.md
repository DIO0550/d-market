---
name: feature-spec
description: 機能仕様書・PRD作成スキル。1機能をページ単位・エンドポイント単位・テーブル単位に分割したMarkdown仕様書群を対話的に生成する。「機能仕様書を書きたい」「ページの仕様を作りたい」「PRDを作りたい」「画面仕様をまとめたい」「ユーザーストーリーを整理したい」「機能の要件定義をしたい」などのリクエスト時に使用。
---

# Feature Spec - Feature Specification & PRD Generator

機能仕様書またはPRDをMarkdownで対話的に作成するスキル。
機能仕様書は**ページ・エンドポイント・テーブル単位に分割**して管理しやすいサイズに保つ。

## Document Formats

### Feature Spec (分割構成)

1機能 = 1フォルダ。概要ドキュメント + 各単位の個別仕様書で構成。

```
docs/{feature-name}/
├── overview.md                  # 機能概要・画面遷移・一覧
├── pages/
│   ├── {page-name}.md           # ページ単位の仕様
│   └── ...
├── endpoints/
│   ├── {method}-{resource}.md   # エンドポイント単位の仕様
│   └── ...
└── tables/
    ├── {table-name}.md          # テーブル単位の仕様
    └── ...
```

Templates:
| Template | Path | Granularity |
|:---------|:-----|:-----------|
| Overview | `assets/templates/overview.md` | 1 per feature |
| Page | `assets/templates/page.md` | 1 per page |
| Endpoint | `assets/templates/endpoint.md` | 1 per endpoint |
| Table | `assets/templates/table.md` | 1 per table |

### PRD

単一ファイル構成のプロダクト要件定義書。

Template: `assets/templates/prd.md`

## Workflow

```
1. Determine document format (Feature Spec or PRD)
   ↓
2. Hearing: basics + scope
   ↓
3. [Feature Spec] Hearing: pages, endpoints, tables to spec
   ↓
4. Generate overview.md first
   ↓
5. Generate individual specs (pages → endpoints → tables)
   ↓
6. Present to user for review
   ↓
7. Revise if requested → Write final documents
```

## Step 1: Determine Format

- "機能仕様書" / "feature spec" / "画面仕様" → **Feature Spec**
- "PRD" / "プロダクト要件" / "要件定義書" → **PRD** (single file, see `assets/templates/prd.md`)
- Ambiguous → Ask with AskUserQuestion

For PRD: follow the simple single-file flow (hear → generate → review → write).
The rest of this document focuses on the **Feature Spec** multi-file flow.

## Step 2: Hearing

Read `references/hearing-patterns.md` and follow the batched hearing flow.

Rules:
- 1-4 questions per batch using AskUserQuestion
- Skip questions the user already answered
- Match the user's language

## Step 3: Generate Documents

### 3.1 Overview first

1. Read `assets/templates/overview.md`
2. Fill in purpose, background, scope, user stories
3. Create the screen flow diagram (Mermaid flowchart)
4. List all pages, endpoints, tables with links to their spec files
5. Write to `docs/{feature-name}/overview.md`

### 3.2 Individual specs

For each page/endpoint/table identified in the hearing:

1. Read the corresponding template
2. Fill in sections based on hearing results
3. Cross-link to related specs (page ↔ endpoint ↔ table)
4. Write to the appropriate subdirectory

**Adaptation rules** (see `references/hearing-patterns.md`):
- Page has no form → skip Forms section
- Endpoint has no side effects → skip Side Effects section
- Table has no seed data → skip Seed Data section
- Skip any section that is not relevant

### 3.3 Generation order

1. `overview.md` → establish structure and names
2. `pages/*.md` → one file per page
3. `endpoints/*.md` → one file per endpoint
4. `tables/*.md` → one file per table

Present each generated file briefly to the user as it's created.

## Step 4: Present & Revise

After all files are generated:
1. Show a summary: file count, file list
2. Ask if revisions are needed for any specific file
3. Apply changes if requested
4. Show final directory structure

## Output

**Default output directory**: `docs/`
**Custom output**: If user specifies a path, use that instead.

PRD: `docs/prd-{name}.md`
