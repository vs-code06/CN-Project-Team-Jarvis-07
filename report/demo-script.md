# Demo Script — Phase 1 Presentation

## Pre-Demo Checklist

- [ ] Mac 1 running dnsmasq on 10.7.12.6
- [ ] Mac 2 running nginx on 10.7.3.73
- [ ] Mac 3 running Backend A: `node server.js A 3001`
- [ ] Mac 4 running Backend B: `node server.js B 3002`
- [ ] Client DNS set to 10.7.12.6
- [ ] Team1 CA trusted on client Mac
- [ ] Wireshark ready on Mac 4

---

## Demo 1 — IP Connectivity (Task A)

```bash
ping -c 3 10.7.12.6
ping -c 3 10.7.3.73
ping -c 3 10.7.26.81
ping -c 3 10.7.6.162
```

**Show:** All four Macs are reachable on the LAN.

---

## Demo 2 — DNS (Task B)

```bash
dig app.team1.test
dig api.team1.test
```

**Show:** Both domains resolve to `10.7.3.73`.

---

## Demo 3 — Direct Backend Access (Task C)

```bash
curl -i http://10.7.26.81:3001/api/status
curl -i http://10.7.6.162:3002/api/status
```

**Show:** Each backend returns its identity (A or B).

---

## Demo 4 — Load Balancing (Task D)

```bash
for i in 1 2 3 4 5 6; do
    /usr/bin/curl -s -i https://app.team1.test/api/status | grep -i "X-Backend"
done
```

**Show:** Alternating A/B responses.

---

## Demo 5 — HTTPS (Task E)

```bash
/usr/bin/curl -v https://app.team1.test/api/status
```

**Show:** TLS handshake succeeds, certificate is trusted, no `-k` flag.

---

## Demo 6 — Caching (Task F)

```bash
# First request — 200 with ETag
/usr/bin/curl -sI https://app.team1.test/api/cached

# Conditional request — 304
/usr/bin/curl -i \
    -H 'If-None-Match: <ETAG_FROM_ABOVE>' \
    https://app.team1.test/api/cached
```

**Show:** 304 Not Modified response.

---

## Demo 7 — Wireshark (Task G)

1. Start Wireshark capture on Mac 4 (`en0`)
2. Run:

```bash
/usr/bin/curl -v --tlsv1.2 --tls-max 1.2 https://app.team1.test/api/status
```

3. Stop capture
4. Apply filters:
   - `dns` — DNS query
   - `tcp.flags.syn==1 && tcp.port==443` — TCP handshake
   - `tls.handshake` — TLS handshake
   - `tls.record.content_type == 23` — Encrypted data

**Show:** Complete packet lifecycle.

---

## Demo 8 — Failure: One Backend Down

1. Stop Backend A on Mac 3 (`Ctrl+C`)
2. Run load balancing test:

```bash
for i in 1 2 3 4 5 6; do
    /usr/bin/curl -s -i https://app.team1.test/api/status | grep -i "X-Backend"
done
```

**Show:** All responses are `X-Backend: B`.

3. Restart Backend A: `node server.js A 3001`
4. Wait 10 seconds, re-run test — A/B alternating again.

---

## Demo 9 — Failure: Both Backends Down

1. Stop both backends
2. Run:

```bash
/usr/bin/curl -v https://app.team1.test/api/status
```

**Show:** `502 Bad Gateway`.

3. Restart both backends.
