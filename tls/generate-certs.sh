#!/bin/bash
# Generate Team1 Local CA and server certificates
# Run this script ONCE on the Mac that manages certificates
#
# Output files:
#   ca.key    — CA private key (NEVER commit to Git)
#   ca.crt    — CA certificate (distribute to clients)
#   app.key   — Server private key (NEVER commit to Git)
#   app.csr   — Certificate signing request
#   app.crt   — Server certificate (used by nginx)

set -e

echo "=== Generating Team1 Local CA ==="

# 1. Generate CA private key
openssl genrsa -out ca.key 2048

# 2. Generate CA certificate (self-signed, valid for 365 days)
openssl req -x509 -new -nodes \
    -key ca.key \
    -sha256 \
    -days 365 \
    -out ca.crt \
    -subj "/C=IN/ST=Maharashtra/O=Team1/CN=Team1 Local CA"

echo "=== Generating Server Certificate ==="

# 3. Generate server private key
openssl genrsa -out app.key 2048

# 4. Create SAN configuration file
cat > san.cnf <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage=digitalSignature,keyEncipherment
subjectAltName=@alt_names

[alt_names]
DNS.1=app.team1.test
DNS.2=api.team1.test
EOF

# 5. Generate CSR (certificate signing request)
openssl req -new \
    -key app.key \
    -out app.csr \
    -subj "/C=IN/ST=Maharashtra/O=Team1/CN=app.team1.test"

# 6. Sign the server certificate with our CA
openssl x509 -req \
    -in app.csr \
    -CA ca.crt \
    -CAkey ca.key \
    -CAcreateserial \
    -out app.crt \
    -days 365 \
    -sha256 \
    -extfile san.cnf

echo ""
echo "=== Done ==="
echo ""
echo "Files generated:"
echo "  ca.key   — CA private key (keep secret)"
echo "  ca.crt   — CA certificate (install on clients)"
echo "  app.key  — Server private key (use on nginx)"
echo "  app.csr  — Certificate signing request"
echo "  app.crt  — Server certificate (use on nginx)"
echo ""
echo "Verify the certificate:"
echo "  openssl x509 -in app.crt -text -noout"
