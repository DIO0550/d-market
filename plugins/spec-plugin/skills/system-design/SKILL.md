---
name: system-design
description: システム設計書作成スキル。アーキテクチャ設計書、ADR（Architecture Decision Record）、C4モデル図を含む設計ドキュメントをMarkdown形式で対話的に生成する。「システム設計書を書きたい」「アーキテクチャを文書化したい」「ADRを書きたい」「C4モデルで設計を整理したい」「インフラ構成をまとめたい」「コンポーネント設計を記録したい」「技術的な意思決定を記録したい」などのリクエスト時に使用。
---

# System Design - System Design Document Generator

システム設計ドキュメントを対話的に作成するスキル。3つのドキュメント形式に対応。

## Document Formats

| Format | Template | Use Case |
|:-------|:---------|:---------|
| System Design | `assets/templates/system-design.md` | Full architecture: components, data, infra, NFR |
| ADR | `assets/templates/adr.md` | Record a single architectural decision with context and consequences |
| C4 Model | `assets/templates/c4-model.md` | Layered architecture views: Context → Container → Component → Code |

## Workflow

```
1. Determine document format
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
- "システム設計" / "アーキテクチャ設計" / "インフラ構成" → **System Design**
- "ADR" / "意思決定記録" / "技術選定の記録" / "decision record" → **ADR**
- "C4" / "C4モデル" / "コンテキスト図" / "コンテナ図" → **C4 Model**
- Ambiguous → Ask with AskUserQuestion

## Step 2: Hearing

Read `references/hearing-patterns.md` and follow the batched hearing flow.

Rules:
- 1-4 questions per batch using AskUserQuestion
- Skip questions the user already answered
- Match the user's language
- ADR: Focus on the decision context, options considered, and trade-offs
- C4: Focus on system boundaries, containers, and component responsibilities

## Step 3: Generate Document

1. Read the template from `assets/templates/`
2. Fill in sections based on hearing results
3. Adapt sections (see `references/hearing-patterns.md` Section Adaptation Rules)
4. Format-specific rules:
   - **System Design**: Mermaid diagrams for architecture, sequence, state, ER
   - **ADR**: Concise and focused on one decision; link to related ADRs
   - **C4 Model**: Mermaid C4 diagrams at each level; only drill down to levels relevant to the discussion

## Step 4: Present & Revise

1. Show brief summary of generated document
2. Ask if revisions are needed
3. Apply changes if requested → present again
4. If approved → write to file

## Step 5: Write Output

**Default output directory**: `docs/`
**Custom output**: If user specifies a path, use that instead.

File naming:
- `docs/system-design-{name}.md`
- `docs/adr-{NNN}-{name}.md` (NNN = sequential number)
- `docs/c4-model-{name}.md`
