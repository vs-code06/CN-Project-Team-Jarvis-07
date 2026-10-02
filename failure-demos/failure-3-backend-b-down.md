# Failure Demo 3: One Backend Down (nginx Failover)

## Scenario

Backend A (Mac 3 — 10.7.26.81:3001) is stopped. Backend B (Mac 4 — 10.7.6.162:3002) remains running.

nginx should detect the failure and route all traffic to the healthy backend.

## Steps to Reproduce

### 1. Stop Backend A on Mac 3

On Mac 3, stop the Node.js process:

```bash
# Find and kill the backend process
pkill -f "node server.js A 3001"
```

Or press `Ctrl+C` in the terminal running Backend A.

### 2. Make requests through nginx

```bash
for i in 1 2 3 4 5 6; do
    /usr/bin/curl -s -i https://app.team1.test/api/status | grep -i "X-Backend"
done
```

### Expected Result

All responses should show:

```
X-Backend: B
X-Backend: B
X-Backend: B
X-Backend: B
X-Backend: B
X-Backend: B
```

nginx detects that Backend A is unreachable and temporarily removes it from the upstream pool. All requests are routed to Backend B.

## Why This Works

The nginx upstream configuration uses:

```nginx
upstream backends {
    server 10.7.26.81:3001 max_fails=1 fail_timeout=10s;
    server 10.7.6.162:3002 max_fails=1 fail_timeout=10s;
}
```

- `max_fails=1` — after 1 failed connection attempt, mark the upstream as unavailable
- `fail_timeout=10s` — wait 10 seconds before trying the failed upstream again

## Layer Analysis

| Layer | Status |
|-------|--------|
| DNS   | ✅ Works |
| TCP   | ✅ Connects to nginx on 443 |
| TLS   | ✅ Handshake succeeds |
| HTTP  | ✅ 200 OK (from Backend B only) |
| Load Balancing | ⚠️ Degraded — single backend |

## Restoration

### 1. Restart Backend A on Mac 3

```bash
cd ~/cn-backend
node server.js A 3001
```

### 2. Wait ~10 seconds for nginx to retry

### 3. Verify round-robin is restored

```bash
for i in 1 2 3 4 5 6; do
    /usr/bin/curl -s -i https://app.team1.test/api/status | grep -i "X-Backend"
done
```

Expected:

```
X-Backend: A
X-Backend: B
X-Backend: A
X-Backend: B
X-Backend: A
X-Backend: B
```
