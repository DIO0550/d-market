# {Method} {Path}

> **Feature**: [{Feature Name}](../overview.md)
> **Status**: Draft | Review | Approved

## 1. Purpose

{What this endpoint does, in 1 sentence}

## 2. Request

### 2.1 Headers

| Header | Required | Description |
|:-------|:---------|:-----------|
| Authorization | Yes/No | {description} |

### 2.2 Path Parameters

| Parameter | Type | Description | Example |
|:----------|:-----|:-----------|:--------|
| {param} | {type} | {description} | {example} |

### 2.3 Query Parameters

| Parameter | Type | Required | Default | Description |
|:----------|:-----|:---------|:--------|:-----------|
| {param} | {type} | Yes/No | {default} | {description} |

### 2.4 Request Body

```json
{
  "field": "type (required/optional) - description"
}
```

**Validation Rules**:
| Field | Rule | Error Code |
|:------|:-----|:-----------|
| {field} | {rule} | {code} |

## 3. Response

### 3.1 Success

**Status**: `{200/201/204}`

```json
{
  "data": {}
}
```

### 3.2 Error Responses

| Status | Code | Condition |
|:-------|:-----|:----------|
| 400 | {code} | {condition} |
| 401 | UNAUTHORIZED | {condition} |
| 404 | NOT_FOUND | {condition} |

## 4. Business Logic

{Key processing steps or rules applied by this endpoint}

1. {Step 1}
2. {Step 2}

## 5. Side Effects

| Side Effect | Description |
|:-----------|:-----------|
| {e.g., send email} | {when and what} |
| {e.g., update cache} | {what gets invalidated} |

## 6. Related

- Page: [{page name}](../pages/{page-name}.md)
- Table: [{table name}](../tables/{table-name}.md)
