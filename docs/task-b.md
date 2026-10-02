# Task B — Private DNS

## Objective

Configure a private DNS server so that custom domain names resolve to the correct LAN IP addresses.

## DNS Server

| Setting | Value |
|---------|-------|
| Machine | Mac 1 |
| IP | 10.7.12.6 |
| Software | dnsmasq |
| Port | 53 |

## DNS Records

| Domain | Resolves To | Target Machine |
|--------|-------------|----------------|
| `app.team1.test` | 10.7.3.73 | Mac 2 (nginx) |
| `api.team1.test` | 10.7.3.73 | Mac 2 (nginx) |

Both domains point to the nginx reverse proxy, **not** directly to the backends.

## Configuration

See [`config/dnsmasq.conf`](../config/dnsmasq.conf)

## Client Setup

On each client Mac, set the DNS server to Mac 1:

```bash
./scripts/set-dns.sh 10.7.12.6
```

To restore default DNS:

```bash
./scripts/set-dns.sh empty
```

## Verification

```bash
dig app.team1.test
# Expected ANSWER: 10.7.3.73

dig api.team1.test
# Expected ANSWER: 10.7.3.73
```

Or query the DNS server directly:

```bash
dig @10.7.12.6 app.team1.test
```

## Evidence

Screenshots of `dig` output are in the `evidence/` directory.
