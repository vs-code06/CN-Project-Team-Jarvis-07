# Task D — Load Balancing

## Objective

Use nginx as a reverse proxy with round-robin load balancing across two backends.

## nginx Configuration

See [`config/nginx.conf`](../config/nginx.conf)

The upstream block:

```nginx
upstream backends {
    server 10.7.26.81:3001 max_fails=1 fail_timeout=10s;
    server 10.7.6.162:3002 max_fails=1 fail_timeout=10s;
}
```

nginx uses **default round-robin** — no additional directives needed.

## How It Works

1. Client connects to `https://app.team1.test` → nginx (10.7.3.73:443)
2. nginx forwards request 1 to Backend A (10.7.26.81:3001)
3. nginx forwards request 2 to Backend B (10.7.6.162:3002)
4. nginx forwards request 3 to Backend A
5. ...and so on, alternating

## Verification

```bash
for i in 1 2 3 4 5 6; do
    /usr/bin/curl -s -i https://app.team1.test/api/status | grep -i "X-Backend"
done
```

Expected output:

```
X-Backend: A
X-Backend: B
X-Backend: A
X-Backend: B
X-Backend: A
X-Backend: B
```

## Failover

If one backend goes down, nginx automatically routes all traffic to the healthy backend. See [failure-demos.md](failure-demos.md) for details.

## Evidence

Screenshots of load balancing output are in the `evidence/` directory.
