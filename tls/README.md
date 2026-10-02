# TLS Certificates — Team Jarvis 07

## Overview

This project uses a **local Certificate Authority (CA)** to issue TLS certificates for the Team Jarvis 07 private network. No public CA or Let's Encrypt is used — this is a LAN-only setup.

## Certificate Files

| File       | Description                              | Secret? |
|------------|------------------------------------------|---------|
| `ca.key`   | CA private key                           | **YES** — never commit to Git |
| `ca.crt`   | CA public certificate                    | No — distribute to all clients |
| `app.key`  | Server private key (used by nginx)       | **YES** — never commit to Git |
| `app.csr`  | Certificate signing request              | No — intermediate artifact |
| `app.crt`  | Server certificate (used by nginx)       | No — public certificate |

## Subject Alternative Names (SAN)

The server certificate covers both domains:

```
DNS.1 = app.team1.test
DNS.2 = api.team1.test
```

## Generating Certificates

Run the generation script:

```bash
cd tls/
chmod +x generate-certs.sh
./generate-certs.sh
```

This generates all five files in the `tls/` directory.

## nginx Configuration

Copy the certificate and key to the nginx Mac (Mac 2 — 10.7.3.73):

```
ssl_certificate     /Users/utkarshjain/team1-tls/app.crt;
ssl_certificate_key /Users/utkarshjain/team1-tls/app.key;
```

## Trusting the CA on Client Macs

Each client Mac must trust the Team1 CA certificate. Add it to the macOS System Keychain:

```bash
sudo security add-trusted-cert \
    -d \
    -r trustRoot \
    -k /Library/Keychains/System.keychain \
    ca.crt
```

After this, macOS applications (including Safari, Chrome, and `/usr/bin/curl`) will trust certificates signed by our CA.

## Verification

Verify the certificate details:

```bash
openssl x509 -in app.crt -text -noout
```

Check that the SAN section shows:

```
X509v3 Subject Alternative Name:
    DNS:app.team1.test, DNS:api.team1.test
```

## HTTPS Testing

After trusting the CA, test **without** the `-k` flag:

```bash
/usr/bin/curl -v https://app.team1.test/api/status
```

The `-k` flag disables certificate verification and must **NOT** be used in the final demonstration. The whole point is to show that TLS is properly configured with a trusted chain.

## Security Notes

- `ca.key` and `app.key` are excluded by `.gitignore`
- Never share private keys over insecure channels
- The CA certificate (`ca.crt`) is safe to distribute — it contains only the public key
