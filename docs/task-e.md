# Task E — HTTPS / TLS

## Objective

Secure client-to-nginx communication using HTTPS with a locally signed TLS certificate.

## Certificate Setup

| File | Purpose | Secret? |
|------|---------|---------|
| `ca.key` | CA private key | YES |
| `ca.crt` | CA certificate (trusted by clients) | No |
| `app.key` | Server private key (used by nginx) | YES |
| `app.crt` | Server certificate (used by nginx) | No |

See [`tls/README.md`](../tls/README.md) for generation instructions.

## Subject Alternative Names

The server certificate covers both domains:

```
DNS.1 = app.team1.test
DNS.2 = api.team1.test
```

## nginx TLS Configuration

```nginx
server {
    listen 443 ssl;
    server_name app.team1.test api.team1.test;

    ssl_certificate     /Users/utkarshjain/team1-tls/app.crt;
    ssl_certificate_key /Users/utkarshjain/team1-tls/app.key;

    location / {
        proxy_pass http://backends;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## Client Trust

Each client must trust the Team1 CA:

```bash
sudo security add-trusted-cert \
    -d \
    -r trustRoot \
    -k /Library/Keychains/System.keychain \
    ca.crt
```

## Verification

```bash
/usr/bin/curl -v https://app.team1.test/api/status
```

**Important:** Do NOT use `-k`. The certificate must be properly trusted.

Expected:

- DNS resolves `app.team1.test` → `10.7.3.73`
- TCP connects to port 443
- TLS handshake succeeds
- Certificate matches `app.team1.test`
- Certificate chain is trusted
- HTTP 200 OK with `X-Backend` header

## Evidence

Screenshots of HTTPS verification are in the `evidence/` directory.
