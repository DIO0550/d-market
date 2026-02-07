# Hearing Patterns - API Spec

## Common (All Formats)

**Batch 1: Basics**
- What is the API name / service name?
- What is the purpose of this API?
- Who are the consumers? (frontend, mobile, external, other services)
- What is the base URL or service boundary?

**Batch 2: Authentication & Common Behavior**
- What is the authentication method? (Bearer, API Key, OAuth 2.0, none)
- What is the response format? (JSON, XML)
- Are there rate limiting requirements?
- What error handling pattern should be used?

## Markdown API Hearing

**Batch 3: Endpoints**
- What resources / entities does this API manage?
- What operations are needed per resource? (list, get, create, update, delete, custom)
- What are the query parameters for list operations? (filtering, sorting, pagination)
- Are there any webhook or async operations?

## OpenAPI Hearing

**Batch 3: Schema Details**
- What are the main resource schemas? (fields, types, required/optional)
- What are the request body schemas per operation?
- What are the response schemas per status code?
- Are there reusable components? (common headers, error schemas, pagination)

**Batch 4: Operations**
- What are the exact endpoint paths and HTTP methods?
- What path/query parameters does each endpoint accept?
- What are the security scopes per operation?
- API versioning strategy? (URL path, header, query)

## GraphQL Hearing

**Batch 3: Type System**
- What are the main types? (fields, relationships, nullability)
- What are the enum types?
- What are the input types for mutations?
- Are there interfaces or union types?

**Batch 4: Operations**
- What queries are needed? (arguments, return types)
- What mutations are needed? (input, return types)
- Are there subscriptions? (events, payload)
- Custom scalars? (Date, JSON, etc.)

## Section Adaptation Rules

- No auth → skip Authentication section
- No pagination → skip Pagination section
- No rate limiting → skip Rate Limiting section
- No webhooks → skip Webhook section
- GraphQL: No subscriptions → skip Subscription section
- OpenAPI: If simple CRUD → generate from resource schemas automatically
