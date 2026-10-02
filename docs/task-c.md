# Task C — Backend Servers

## Objective

Deploy two identical backend servers on separate Macs, each identified by a unique name.

## Backend Details

| Backend | Machine | IP | Port | Command |
|---------|---------|-----|------|---------|
| A | Mac 3 | 10.7.26.81 | 3001 | `node server.js A 3001` |
| B | Mac 4 | 10.7.6.162 | 3002 | `node server.js B 3002` |

## Implementation

Both backends use the **same** `server.js` file. The backend name and port are passed as command-line arguments.

See [`backend/server.js`](../backend/server.js)

## Endpoints

| Method | Path | Response |
|--------|------|----------|
| GET | `/` | `{ "backend": "A", "message": "Hello from backend A" }` |
| GET | `/api/status` | `{ "backend": "A", "status": "ok" }` + `X-Backend: A` header |
| GET | `/api/cached` | `{ "data": "static content" }` + `Cache-Control: max-age=60` + ETag |

## Setup

On each backend Mac:

```bash
cd backend/
npm install
```

Start Backend A (Mac 3):

```bash
node server.js A 3001
```

Start Backend B (Mac 4):

```bash
node server.js B 3002
```

## Direct Verification (bypass nginx)

```bash
curl -i http://10.7.26.81:3001/api/status
curl -i http://10.7.6.162:3002/api/status
```

## Evidence

Screenshots of direct backend responses are in the `evidence/` directory.
