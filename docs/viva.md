# Viva Preparation — Team Jarvis 07

## Likely Questions and Answers

### 1. Why did you use dnsmasq?

dnsmasq is a lightweight DNS forwarder suitable for small private LANs. It allows us to create custom domain names (`.test` TLD) that resolve to specific IPs on our network without needing a full DNS infrastructure like BIND.

### 2. Why do both domains point to the same IP (10.7.3.73)?

Both `app.team1.test` and `api.team1.test` resolve to the nginx reverse proxy. nginx uses the `Host` header to distinguish between them if needed, but in our setup both are proxied to the same upstream backends.

### 3. Why does the backend listen on 0.0.0.0?

Listening on `0.0.0.0` makes the server accept connections on all network interfaces, including the LAN. If it listened on `127.0.0.1`, it would only accept connections from the same machine.

### 4. What is round-robin load balancing?

nginx distributes requests to upstream servers in sequential order: first to Backend A, then Backend B, then A again. This is the default behavior without any additional configuration.

### 5. What happens if one backend goes down?

nginx's `max_fails=1 fail_timeout=10s` configuration means that after one failed connection attempt, nginx marks that backend as unavailable for 10 seconds and sends all traffic to the healthy backend.

### 6. What is a 502 Bad Gateway?

A 502 occurs when nginx (the gateway/proxy) cannot get a valid response from any upstream server. This happens when both backends are down.

### 7. Why do you use a local CA instead of Let's Encrypt?

Let's Encrypt cannot issue certificates for `.test` domains or private LAN IPs. A local CA lets us create valid certificates for our custom domains and demonstrates the full PKI trust chain.

### 8. Why must clients trust the CA certificate?

Without trusting the CA, the TLS handshake fails because the client cannot verify the certificate chain. This is similar to how browsers trust certificates from well-known CAs.

### 9. Why not use `curl -k`?

The `-k` flag skips certificate verification, which defeats the purpose of TLS. Our demonstration proves that the certificate chain is properly configured and trusted.

### 10. What is the ETag used for?

The ETag is a fingerprint of the response content. When the client sends `If-None-Match` with a previously received ETag, the server can respond with `304 Not Modified` instead of retransmitting the same data, saving bandwidth.

### 11. What is the difference between TLS 1.2 and 1.3 in Wireshark?

TLS 1.2 shows the Certificate message in cleartext during the handshake. TLS 1.3 encrypts more of the handshake, so the certificate is not directly visible. We use `--tlsv1.2 --tls-max 1.2` in curl to force TLS 1.2 for clearer Wireshark analysis.

### 12. What does `tls.record.content_type == 23` mean?

Content type 23 is "Application Data" in the TLS protocol. These records contain the encrypted HTTP request and response, proving that the traffic is encrypted.

### 13. What is the `.test` TLD?

RFC 6761 reserves `.test` for testing and documentation purposes. It will never be registered as a real TLD, making it safe for private network experiments.

### 14. What is the role of the `X-Backend` header?

It's a custom header set by our backend to identify which server handled the request. This is how we verify that load balancing is working correctly.

### 15. What port does DNS use?

DNS uses port 53, typically over UDP for queries and TCP for zone transfers or large responses.
