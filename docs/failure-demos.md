# Failure Demonstrations

## Overview

These demonstrations show what happens when specific network components fail or are misconfigured. Each failure is isolated to a single layer, proving understanding of the network stack.

## Failure Scenarios

### Failure 1 — Wrong DNS Server

**Scenario:** Client DNS is set to `8.8.8.8` instead of `10.7.12.6`.

**Result:** `app.team1.test` fails to resolve (NXDOMAIN). Direct IP access still works.

**Layer:** DNS

See [`failure-demos/failure-1-wrong-dns.sh`](../failure-demos/failure-1-wrong-dns.sh)

---

### Failure 2 — DNS Record Points to Wrong IP

**Scenario:** `app.team1.test` resolves to `10.7.26.81` (Mac 3) instead of `10.7.3.73` (Mac 2).

**Result:** DNS resolves, but TCP connection to port 443 is refused (Mac 3 doesn't run nginx).

**Layer:** DNS → TCP

See [`failure-demos/failure-2-wrong-dns-record.md`](../failure-demos/failure-2-wrong-dns-record.md)

---

### Failure 3 — One Backend Down

**Scenario:** Backend A is stopped. Backend B remains healthy.

**Result:** nginx fails over to Backend B. All responses show `X-Backend: B`.

**Layer:** Application (nginx failover)

See [`failure-demos/failure-3-backend-b-down.md`](../failure-demos/failure-3-backend-b-down.md)

---

### Failure 4 — Both Backends Down

**Scenario:** Both Backend A and Backend B are stopped.

**Result:** nginx returns `502 Bad Gateway`. DNS and TLS still work.

**Layer:** Application (no upstream available)

See [`failure-demos/failure-4-both-backends-down.md`](../failure-demos/failure-4-both-backends-down.md)

---

### Failure 5 — Wrong HTTPS Port

**Scenario:** Client connects to `https://app.team1.test:8444/` (wrong port).

**Result:** Connection refused. Ping still works.

**Layer:** TCP (transport)

See [`failure-demos/failure-5-wrong-port.sh`](../failure-demos/failure-5-wrong-port.sh)

## Summary Table

| # | Failure | Broken Layer | Result |
|---|---------|-------------|--------|
| 1 | Wrong DNS server | DNS | NXDOMAIN |
| 2 | Wrong DNS record | DNS → TCP | Connection refused |
| 3 | One backend down | Application | Failover (single backend) |
| 4 | Both backends down | Application | 502 Bad Gateway |
| 5 | Wrong port | TCP | Connection refused |
