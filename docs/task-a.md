# Task A — IP Addressing and Connectivity

## Objective

Verify that all four Macs are on the same private LAN and can reach each other via IP.

## Network Configuration

| Machine | Role | IP Address |
|---------|------|------------|
| Mac 1 | Private DNS | 10.7.12.6 |
| Mac 2 | nginx Edge | 10.7.3.73 |
| Mac 3 | Backend A | 10.7.26.81 |
| Mac 4 | Backend B + Client | 10.7.6.162 |

## Verification

From any Mac, ping all other Macs:

```bash
ping -c 3 10.7.12.6
ping -c 3 10.7.3.73
ping -c 3 10.7.26.81
ping -c 3 10.7.6.162
```
 
All pings should succeed with replies, confirming Layer 3 (IP) connectivity on the private LAN.

## Evidence

Screenshots showing successful pings between all Macs are in the `evidence/` directory.
