# Backend Server

Node.js + Express backend used by both Mac 3 (Backend A) and Mac 4 (Backend B).

The **same** `server.js` is deployed on both machines. The backend identity and port are passed as command-line arguments.

## Setup

```bash
cd backend
npm install
```

## Usage

**Backend A** (Mac 3 — 10.7.26.81):

```bash
node server.js A 3001
```

**Backend B** (Mac 4 — 10.7.6.162):

```bash
node server.js B 3002
```

## Endpoints

| Method | Path          | Description                          |
|--------|---------------|--------------------------------------|
| GET    | `/`           | Returns backend identity and message |
| GET    | `/api/status` | Returns status JSON with `X-Backend` header |
| GET    | `/api/cached` | Returns static JSON with `Cache-Control: max-age=60` and ETag |

## Response Headers

Every response from `/api/status` and `/api/cached` includes:

```
X-Backend: A
```

or:

```
X-Backend: B
```

This header is used by the load balancing verification scripts to confirm nginx round-robin behavior.

## Important Notes

- The server listens on `0.0.0.0`, **not** `127.0.0.1`, so it is reachable from other Macs on the LAN.
- Express automatically generates an `ETag` header for JSON responses, which is used for cache validation (304 Not Modified).
