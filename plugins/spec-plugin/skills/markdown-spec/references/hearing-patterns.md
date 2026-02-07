# Hearing Patterns

Spec type selection and hearing patterns for each specification type.

## Spec Type Selection

First, determine the specification type from the user's request:

| Trigger Keywords | Spec Type | Template |
|:-----------------|:----------|:---------|
| feature, function, user story, screen, UI | Feature Spec | `feature-spec.md` |
| API, endpoint, REST, GraphQL, request, response | API Spec | `api-spec.md` |
| architecture, system, infrastructure, component | System Design | `system-design.md` |
| (ambiguous or multiple) | Ask user | - |

## Hearing Flow

Ask questions in batches of 1-4. Use AskUserQuestion format.

### Common (All Types)

**Batch 1: Basics**
- What is the name / title?
- What is the purpose? (1-2 sentences)
- What is the scope? (in scope / out of scope)
- Who are the target users or consumers?

### Feature Spec Specific

**Batch 2: User Requirements**
- What are the main user stories? (As a... I want to... So that...)
- What are the key screens / UI elements?
- What are the validation rules?
- Are there any business rules or constraints?

**Batch 3: Technical & Quality**
- What data needs to be stored or processed?
- What are the error handling requirements?
- Are there non-functional requirements? (performance, accessibility)
- What are the dependencies on other features / systems?

### API Spec Specific

**Batch 2: API Design**
- What resources / entities does this API manage?
- What operations are needed? (CRUD, custom actions)
- What is the authentication method? (Bearer, API Key, OAuth)
- What is the response format? (JSON, XML)

**Batch 3: Technical Details**
- What are the rate limiting requirements?
- What are the pagination requirements?
- Are there any versioning considerations?
- What are the error handling patterns?

### System Design Specific

**Batch 2: Architecture**
- What are the main components of the system?
- What external systems does it integrate with?
- What is the technology stack? (or constraints)
- What is the data model?

**Batch 3: Non-Functional & Operations**
- What are the performance targets? (latency, throughput)
- What is the availability target? (SLA)
- What is the scalability requirement?
- What are the security requirements?
- What is the deployment strategy?

## Section Adaptation Rules

Not all template sections are required. Adapt based on user input:

- If the user has no UI → skip Screen/UI Specification
- If the user has no external dependencies → skip Dependencies
- If simple CRUD → simplify State Diagram
- If no data persistence → skip Data Migration
- If code example is relevant (e.g., library, SDK) → include code blocks
- If code example is not relevant (e.g., business feature) → omit code blocks
