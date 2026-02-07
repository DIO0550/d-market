# Hearing Patterns - Feature Spec & PRD

## Feature Spec Hearing

### Batch 1: Basics

- What is the feature name?
- What problem does it solve? (1-2 sentences)
- Who are the target users?
- What is in scope / out of scope?

### Batch 2: Pages

- What pages are needed for this feature? (list page names)
- What is the navigation flow between pages? (screen transitions)
- For each page: what is its main purpose?
- Are there any shared layouts or components across pages?

### Batch 3: Endpoints

- What API endpoints does this feature need?
- For each endpoint: method, path, brief description
- What authentication/authorization is required?
- Are there any batch operations or async processes?

### Batch 4: Tables

- What database tables does this feature need? (new or modified)
- For each table: what are the key columns?
- What are the relationships between tables?
- Any data migration from existing tables?

### Batch 5: Quality (ask only if not already covered)

- Error handling requirements?
- Performance requirements?
- Accessibility requirements?

## PRD Hearing

### Batch 1: Context

- What is the product / feature name?
- What problem does it solve? (quantify if possible)
- Who are the target users?
- What is in scope / out of scope?

### Batch 2: Product Goals

- What does success look like? (metrics / KPIs)
- What are the user personas and their key needs?
- Any competitive context or constraints?

### Batch 3: Solution & Scope

- What is the proposed solution at a high level?
- Are there phases or MVP vs. full scope?
- What are the risks and open questions?
- Any timeline or launch constraints?

## Section Adaptation Rules

### Page spec
- No form → skip Forms section
- No complex state → simplify State Diagram
- Static page → skip State Management entirely
- No accessibility requirements specified → skip Accessibility section

### Endpoint spec
- No path/query params → skip those sections
- No request body (GET/DELETE) → skip Request Body
- No side effects → skip Side Effects section
- No business logic beyond CRUD → simplify Business Logic

### Table spec
- No foreign keys → skip Relationships diagram
- No seed data → skip Seed Data section
- No special indexes → skip Indexes section
- Simple lifecycle → skip Data Lifecycle section

### General
- Skip any section where the user explicitly said "not needed"
- If only pages are needed (no backend) → skip endpoints/ and tables/ directories
- If only endpoints are needed → skip pages/ and tables/ directories
