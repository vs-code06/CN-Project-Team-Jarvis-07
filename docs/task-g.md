# Task G — Wireshark Packet Capture

## Objective

Capture and analyze network traffic to demonstrate the complete lifecycle of an HTTPS request at the packet level.

## Capture Setup

| Setting | Value |
|---------|-------|
| Machine | Mac 4 (10.7.6.162) |
| Interface | `en0` |
| File | `phase1.pcapng` |

## Capture Command

To generate traffic for capture, use TLS 1.2 for better Wireshark visibility:

```bash
/usr/bin/curl -v --tlsv1.2 --tls-max 1.2 https://app.team1.test/api/status
```

TLS 1.2 is used because the Certificate message is visible in the handshake. TLS 1.3 encrypts more of the handshake, making it harder to inspect.

## Wireshark Display Filters

See [`wireshark/filters.md`](../wireshark/filters.md) for complete filter documentation.

| Filter | Shows |
|--------|-------|
| `dns` | DNS query and response |
| `tcp.flags.syn==1 && tcp.port==443` | TCP connection setup to HTTPS |
| `tls.handshake` | TLS handshake messages |
| `tls.record.content_type == 23` | Encrypted application data |
| `tls && ip.addr == 10.7.3.73 && tcp.port == 443` | Complete TLS session to nginx |

## What the Capture Demonstrates

1. **DNS** — client queries Mac 1 for `app.team1.test`, receives `10.7.3.73`
2. **TCP 3-way handshake** — SYN → SYN-ACK → ACK to nginx on port 443
3. **TLS handshake** — Client Hello, Server Hello, Certificate, Key Exchange, Finished
4. **Encrypted data** — HTTP request/response inside TLS (content type 23)
5. **TCP teardown** — FIN/ACK sequence

## Evidence

Screenshots of Wireshark analysis are in the `evidence/` directory.
