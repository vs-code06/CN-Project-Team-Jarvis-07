# Failure Demo 4: Both Backends Down (502 Bad Gateway)

## Scenario

Both Backend A (Mac 3) and Backend B (Mac 4) are stopped. nginx has no healthy upstream servers.

## Steps to Reproduce

### 1. Stop Backend A on Mac 3

```bash
pkill -f "node server.js A 3001"
```

### 2. Stop Backend B on Mac 4

```bash
pkill -f "node server.js B 3002"
```

### 3. Make a request through nginx

```bash
/usr/bin/curl -v https://app.team1.test/api/status
```

### Expected Result

```
HTTP/1.1 502 Bad Gateway
Server: nginx
```

nginx returns **502 Bad Gateway** because it cannot connect to any upstream backend.

## Layer Analysis

| Layer | Status |
|-------|--------|
| DNS   | ✅ Resolves to 10.7.3.73 |
| TCP   | ✅ Connects to nginx on 443 |
| TLS   | ✅ Handshake succeeds |
| HTTP  | ❌ 502 Bad Gateway |
| Backend | ❌ Both unreachable |

The failure occurs **between nginx and the backends**, not between the client and nginx. DNS, TCP, and TLS all work correctly. The 502 error tells the client that the gateway (nginx) could not get a valid response from its upstream servers.

## Restoration

### 1. Restart Backend A on Mac 3

```bash
cd ~/cn-backend
node server.js A 3001
```

### 2. Restart Backend B on Mac 4

```bash
cd ~/cn-backend
node server.js B 3002
```

### 3. Verify

```bash
/usr/bin/curl -v https://app.team1.test/api/status
# Should return 200 OK
```
