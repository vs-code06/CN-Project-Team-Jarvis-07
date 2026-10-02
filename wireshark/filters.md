# Wireshark Display Filters

## 1. DNS Queries

```
dns
```

**What it shows:** DNS query and response packets. You should see the client querying for `app.team1.test` and receiving `10.7.3.73` as the answer from the DNS server at `10.7.12.6`.

---

## 2. TCP SYN (Connection Setup)

```
tcp.flags.syn==1 && tcp.port==443
```

**What it shows:** TCP SYN packets for HTTPS connections. This filter captures the beginning of the TCP 3-way handshake (SYN and SYN-ACK) between the client and nginx on port 443.

---

## 3. TLS Handshake

```
tls.handshake
```

**What it shows:** All TLS handshake messages including:
- **Client Hello** — client proposes cipher suites and TLS version
- **Server Hello** — server selects cipher suite and TLS version
- **Certificate** — server sends its certificate (visible in TLS 1.2)
- **Key Exchange** — Diffie-Hellman or RSA key exchange
- **Finished** — handshake completion

---

## 4. Encrypted Application Data

```
tls.record.content_type == 23
```

**What it shows:** TLS Application Data records (content type 23). These contain the actual encrypted HTTP request and response. You cannot see the plaintext, but the presence of these records proves that the HTTP traffic is encrypted inside TLS.

---

## 5. Complete TLS Session to nginx (Recommended)

```
tls && ip.addr == 10.7.3.73 && tcp.port == 443
```

**What it shows:** All TLS traffic between the client and nginx (Mac 2 — 10.7.3.73) on port 443. This is the most useful filter because it isolates the entire HTTPS session in one view:

1. Client Hello
2. Server Hello
3. Certificate (TLS 1.2)
4. Application Data (encrypted HTTP)

---

## TLS 1.2 Evidence Command

To capture a TLS 1.2 session for clearer Wireshark analysis:

```bash
/usr/bin/curl -v --tlsv1.2 --tls-max 1.2 https://app.team1.test/api/status
```

**Why TLS 1.2?** TLS 1.3 encrypts more of the handshake (including the Certificate message), making it harder to inspect in Wireshark. TLS 1.2 keeps the Certificate message visible, which is useful for demonstrating that the correct certificate is being served.

Normal HTTPS requests may negotiate TLS 1.3, which is fine — but for the Wireshark demonstration, TLS 1.2 provides better visibility.
