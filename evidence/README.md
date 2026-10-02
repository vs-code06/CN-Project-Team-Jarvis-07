# Evidence

This directory contains screenshots and terminal output captures demonstrating each task, organized by task component.

## Task B — DNS
- **task-b-dns/task-b-dns-dig.png** — `dig app.team1.test` output showing resolution to `10.7.3.73` via DNS server `10.7.12.6`

## Task C — Backend Servers
- **task-c-backend/task-c-backend-a.png** — Direct `curl -i http://10.7.26.81:3001/api/status` from Anant's Mac (Mac 3) showing `X-Backend: A`
- **task-c-backend/task-cd-backend-loadbalancing.png** — Direct Backend A access followed by 6-request load balancing test showing alternating B/A

## Task D — Load Balancing
- **task-d-load-balancing/task-d-load-balancing.jpeg** — Load balancing test showing 6 requests with alternating `X-Backend: B, A, B, A, B, A`

## Task E — HTTPS / TLS & nginx
- **task-e-https/task-de-nginx-config-tls-cert.png** — nginx.conf displayed on Utkarsh's Mac (Mac 2) with syntax test OK, plus `openssl x509` showing certificate details (CN=app.team1.test, Issuer=Team1 Local CA)
- **task-e-https/task-e-https-tls.png** — Full verbose `curl -v https://app.team1.test/api/status` showing DNS resolution, TLS handshake, `SSL certificate verify ok`, and 200 OK response with `X-Backend: A`

## Task F — Caching
- **task-f-caching/task-f-cache-200.png** — `curl -i https://app.team1.test/api/cached` showing 200 OK with `Cache-Control: max-age=60`, `ETag`, and `X-Backend: B`

## Task G — Wireshark
- **task-g-wireshark/task-g-wireshark-tls-session.jpeg** — Wireshark filter `tls && ip.addr == 10.7.3.73 && tcp.port == 443` showing Client Hello (SNI=app.team1.test), Server Hello, Application Data
- **task-g-wireshark/task-g-wireshark-tcp-tls-lifecycle.jpeg** — Full TCP+TLS connection lifecycle with SYN, Client Hello, Server Hello, RST/ACK, FIN/ACK
- **task-g-wireshark/task-g-wireshark-tcp-syn.jpeg** — TCP SYN packets and TLS handshake with Change Cipher Spec and Application Data
- **task-g-wireshark/task-g-wireshark-tls-overview.jpeg** — Overview of multiple TLS sessions showing Client Hello (SNI=app.team1.test), Server Hello, and encrypted Application Data

## Note

The actual `phase1.pcapng` Wireshark capture file is too large for GitHub and is excluded by `.gitignore`.
