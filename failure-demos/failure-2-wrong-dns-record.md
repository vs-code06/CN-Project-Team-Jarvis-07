# Failure Demo 2: DNS Record Points to Wrong IP

## Scenario

The DNS record for `app.team1.test` is temporarily changed to point to **Mac 3 (10.7.26.81)** instead of **Mac 2 (10.7.3.73)**.

Mac 3 runs Backend A on port 3001 — it does **not** run nginx and does **not** listen on port 443.

## Steps to Reproduce

### 1. Modify dnsmasq configuration on Mac 1

Change:

```
address=/app.team1.test/10.7.3.73
```

To:

```
address=/app.team1.test/10.7.26.81
```

### 2. Restart dnsmasq on Mac 1

```bash
sudo brew services restart dnsmasq
```

### 3. Flush DNS cache on client

```bash
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

### 4. Verify DNS resolves to wrong IP

```bash
dig app.team1.test
```

Expected answer: `10.7.26.81` (wrong — should be `10.7.3.73`)

### 5. Attempt HTTPS connection

```bash
/usr/bin/curl -v https://app.team1.test/api/status
```

**Expected failure:** Connection refused. Mac 3 (10.7.26.81) is not listening on port 443.

DNS resolution succeeds, but the TCP connection to port 443 fails because there is no nginx on that machine.

## Why This Fails

| Layer | Status |
|-------|--------|
| DNS   | ✅ Resolves (but to wrong IP) |
| TCP   | ❌ Connection refused on port 443 |
| TLS   | ❌ Never reached |
| HTTP  | ❌ Never reached |

## Restoration

### 1. Fix dnsmasq configuration on Mac 1

Change back to:

```
address=/app.team1.test/10.7.3.73
```

### 2. Restart dnsmasq

```bash
sudo brew services restart dnsmasq
```

### 3. Flush DNS on client

```bash
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

### 4. Verify

```bash
dig app.team1.test
# Should return 10.7.3.73

/usr/bin/curl -v https://app.team1.test/api/status
# Should return 200 OK
```
