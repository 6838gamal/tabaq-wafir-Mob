# Shared API contract

All endpoints are versioned under `/v1` and receive the authenticated role and
tenant context from the access token. The initial service exposes the
capability catalog so each client can render only its assigned surface:

- `GET /health`
- `GET /v1/platform/apps`
- `GET /v1/platform/features`
- `GET /v1/access/{app}/{role}`

The production resource groups follow the same boundaries:

`/auth`, `/restaurants`, `/catalog`, `/inventory`, `/orders`, `/deliveries`,
`/customers`, `/drivers`, `/payments`, `/maps`, `/notifications`, `/chat`,
`/reviews`, `/analytics`, `/ai`, and `/audit-logs`.