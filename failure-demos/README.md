# Failure Demonstrations

This directory contains documented failure scenarios that demonstrate understanding of the network architecture. Each failure shows what happens when a specific component is misconfigured or unavailable.

## Summary

| # | Failure | Layer Affected | Expected Result |
|---|---------|---------------|-----------------|
| 1 | Wrong DNS server on client | DNS | NXDOMAIN / resolution failure |
| 2 | DNS record points to wrong IP | DNS → TCP | Connection refused (no HTTPS on target) |
| 3 | One backend down | Application | nginx failover to healthy backend |
| 4 | Both backends down | Application | 502 Bad Gateway |
| 5 | Wrong HTTPS port | TCP | Connection refused |

## Important

- These failures are **documented demonstrations**, not automated destructive tests
- Each failure includes the exact commands used, expected output, explanation, and restoration steps
- All failures were demonstrated on the actual 4-Mac LAN setup
- Screenshots/evidence of these failures are in the `evidence/` directory
