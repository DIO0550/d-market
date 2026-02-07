# Hearing Patterns - System Design

## System Design Hearing

**Batch 1: Basics**
- What is the system name?
- What is the purpose of this system? (1-2 sentences)
- What are the goals and non-goals?
- Who are the stakeholders?

**Batch 2: Architecture**
- What are the main components?
- What external systems does it integrate with?
- What is the technology stack? (or constraints)
- What is the data model?

**Batch 3: Non-Functional & Operations**
- Performance targets? (latency, throughput)
- Availability target? (SLA)
- Scalability requirements?
- Security requirements?
- Deployment strategy?

## ADR Hearing

**Batch 1: Context**
- What decision needs to be recorded?
- What is the context / background? (why is this decision needed now)
- What are the constraints or forces at play?

**Batch 2: Options**
- What options were considered? (at least 2)
- What are the pros and cons of each?
- What was the chosen option and why?
- What are the consequences of this decision?

## C4 Model Hearing

**Batch 1: System Context (Level 1)**
- What is the system being designed?
- Who are the users / actors?
- What external systems does it interact with?

**Batch 2: Containers (Level 2)**
- What are the main containers? (apps, services, databases, message queues)
- What technology does each container use?
- How do containers communicate? (HTTP, gRPC, messaging, etc.)

**Batch 3: Components (Level 3) - if needed**
- Which container should be decomposed into components?
- What are the main components within that container?
- What are the responsibilities and interfaces of each component?

Note: Level 4 (Code) is typically not documented in C4 model specs. Only drill down to Level 3 if relevant.

## Section Adaptation Rules

- Simple system → skip Scalability / Infrastructure sections
- No external integrations → skip External APIs section
- ADR: Always keep concise; one decision per document
- C4: Only generate levels that are relevant (e.g., if only Context + Container needed, skip Component level)
- No data persistence → skip Data Migration section
- No async processing → skip Message Queue / Event sections
