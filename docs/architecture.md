# Architecture

## Network Diagram

```
                          PRIVATE LAN
                               |
         -----------------------------------------------
         |            |            |                  |
       Mac 1        Mac 2        Mac 3              Mac 4
       DNS          nginx        Backend A           Backend B
       :53          :443         :3001               :3002
       10.7.12.6    10.7.3.73    10.7.26.81          10.7.6.162
       (Vipul)      (Utkarsh)    (Anant)             (Krishna)
                       |
                 Load Balancer
                    /     \
                   /       \
              Backend A   Backend B
```

## Team Members

| Member | Machine | Role | IP |
|--------|---------|------|-----|
| Vipul Sharma (2401010505) | Mac 1 | Private DNS | 10.7.12.6 |
| Utkarsh Jain (2401020072) | Mac 2 | nginx Edge / TLS | 10.7.3.73 |
| Anant Jain (2401010066) | Mac 3 | Backend A | 10.7.26.81 |
| Krishna Gehlot (2401010236) | Mac 4 | Backend B + Client + Wireshark | 10.7.6.162 |

## Request Flow

When a client on the LAN makes a request to `https://app.team1.test/api/status`:

### 1. DNS Resolution

```
Client → Mac 1 / Vipul (10.7.12.6:53)
       ← app.team1.test = 10.7.3.73
```

The client's DNS is configured to use Mac 1. dnsmasq resolves `app.team1.test` to `10.7.3.73` (Mac 2).

### 2. TCP Connection

```
Client → Mac 2 / Utkarsh (10.7.3.73:443)
       ← SYN-ACK
Client → ACK
```

The client initiates a TCP 3-way handshake with nginx on port 443.

### 3. TLS Handshake

```
Client → Client Hello (supported cipher suites, TLS version)
       ← Server Hello (selected cipher, certificate)
Client    Verifies certificate against trusted Team1 CA
Client → Key Exchange
       ← Finished
```

nginx presents the `app.crt` certificate signed by the Team1 Local CA. The client trusts it because `ca.crt` is installed in the macOS System Keychain.

### 4. HTTP Request (inside TLS)

```
Client → GET /api/status HTTP/1.1
         Host: app.team1.test
```

### 5. nginx Proxies to Backend

```
nginx → Mac 3 / Anant — Backend A (10.7.26.81:3001)  ← round-robin
   or → Mac 4 / Krishna — Backend B (10.7.6.162:3002)
```

nginx selects a backend using round-robin and forwards the request.

### 6. Backend Response

```
Backend → nginx:  { "backend": "A", "status": "ok" }
                   X-Backend: A
```

### 7. nginx Forwards to Client

```
nginx → Client:   HTTP/1.1 200 OK
                   X-Backend: A
                   { "backend": "A", "status": "ok" }
```

## Layer Summary

| Layer | Component | Machine | Member | Port |
|-------|-----------|---------|--------|------|
| DNS | dnsmasq | Mac 1 (10.7.12.6) | Vipul | 53 |
| TCP/TLS | nginx | Mac 2 (10.7.3.73) | Utkarsh | 443 |
| HTTP (upstream) | Express | Mac 3 (10.7.26.81) | Anant | 3001 |
| HTTP (upstream) | Express | Mac 4 (10.7.6.162) | Krishna | 3002 |
