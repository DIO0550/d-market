# {System Name} - C4 Model

> **Version**: 1.0
> **Created**: {YYYY-MM-DD}
> **Author**: {Author}
> **Status**: Draft | Review | Approved

## Overview

{Brief description of the system and what this C4 model documents}

---

## Level 1: System Context Diagram

Shows the system in scope and its relationships with users and external systems.

```mermaid
C4Context
    title System Context Diagram - {System Name}

    Person(user, "User", "Description of user role")
    Person(admin, "Admin", "Description of admin role")

    System(system, "Target System", "Description of what the system does")

    System_Ext(extA, "External System A", "Description")
    System_Ext(extB, "External System B", "Description")

    Rel(user, system, "Uses", "HTTPS")
    Rel(admin, system, "Manages", "HTTPS")
    Rel(system, extA, "Sends data to", "REST API")
    Rel(system, extB, "Fetches data from", "gRPC")
```

### Context Summary

| Element | Type | Description |
|:--------|:-----|:-----------|
| {name} | Person / System / External | {description} |

### Key Relationships

| From | To | Description | Protocol |
|:-----|:---|:-----------|:---------|
| {from} | {to} | {what data/action} | {protocol} |

---

## Level 2: Container Diagram

Shows the containers (applications, data stores, etc.) within the system.

```mermaid
C4Container
    title Container Diagram - {System Name}

    Person(user, "User", "")

    System_Boundary(system, "Target System") {
        Container(web, "Web App", "React", "Serves the SPA to users")
        Container(api, "API Server", "Node.js", "Handles business logic and API")
        ContainerDb(db, "Database", "PostgreSQL", "Stores application data")
        Container(cache, "Cache", "Redis", "Caches frequently accessed data")
        Container(queue, "Message Queue", "RabbitMQ", "Async task processing")
        Container(worker, "Worker", "Node.js", "Processes background tasks")
    }

    System_Ext(extA, "External System A", "")

    Rel(user, web, "Uses", "HTTPS")
    Rel(web, api, "API calls", "HTTPS/JSON")
    Rel(api, db, "Reads/Writes", "TCP")
    Rel(api, cache, "Reads/Writes", "TCP")
    Rel(api, queue, "Publishes", "AMQP")
    Rel(queue, worker, "Consumes", "AMQP")
    Rel(api, extA, "Calls", "REST API")
```

### Container Summary

| Container | Technology | Responsibility |
|:----------|:-----------|:-------------|
| {name} | {technology} | {what it does} |

### Communication Protocols

| From | To | Protocol | Sync/Async | Notes |
|:-----|:---|:---------|:-----------|:------|
| {from} | {to} | {protocol} | Sync/Async | {notes} |

---

## Level 3: Component Diagram

Shows the internal components of a specific container.

### {Container Name} - Components

```mermaid
C4Component
    title Component Diagram - {Container Name}

    Container_Boundary(api, "API Server") {
        Component(controller, "Controller", "Express Router", "Handles HTTP requests")
        Component(service, "Service Layer", "TypeScript", "Business logic")
        Component(repo, "Repository", "TypeScript", "Data access abstraction")
        Component(auth, "Auth Module", "Passport.js", "Authentication & authorization")
    }

    ContainerDb(db, "Database", "PostgreSQL", "")
    Container(cache, "Cache", "Redis", "")

    Rel(controller, auth, "Validates tokens")
    Rel(controller, service, "Calls")
    Rel(service, repo, "Uses")
    Rel(repo, db, "Queries", "SQL")
    Rel(service, cache, "Gets/Sets", "TCP")
```

### Component Summary

| Component | Technology | Responsibility | Interface |
|:----------|:-----------|:-------------|:----------|
| {name} | {technology} | {what it does} | {how others call it} |

### Dependencies

| Component | Depends On | Reason |
|:----------|:----------|:-------|
| {component} | {dependency} | {why} |

---

## Cross-Cutting Concerns

### Authentication & Authorization

| Aspect | Approach |
|:-------|:---------|
| Method | {e.g., JWT Bearer tokens} |
| Authorization model | {e.g., RBAC} |
| Token lifecycle | {e.g., 1h access + 7d refresh} |

### Observability

| Aspect | Tool | Details |
|:-------|:-----|:--------|
| Logging | {tool} | {approach} |
| Metrics | {tool} | {key metrics} |
| Tracing | {tool} | {approach} |

### Error Handling

| Layer | Strategy |
|:------|:---------|
| {layer} | {how errors are handled} |

## Appendix

### Glossary

| Term | Definition |
|:-----|:----------|
| {term} | {definition} |

### Change History

| Version | Date | Changes | Author |
|:--------|:-----|:--------|:-------|
| 1.0 | {YYYY-MM-DD} | Initial draft | {author} |
