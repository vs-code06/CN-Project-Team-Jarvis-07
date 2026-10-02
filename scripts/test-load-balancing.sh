#!/bin/bash
# Test nginx round-robin load balancing
# Expected: alternating A/B responses when both backends are healthy

echo "=== Load Balancing Test ==="
echo ""

for i in 1 2 3 4 5 6; do
    /usr/bin/curl -s -i https://app.team1.test/api/status | grep -i "X-Backend"
done
