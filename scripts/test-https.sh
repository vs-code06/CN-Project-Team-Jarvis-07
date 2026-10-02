#!/bin/bash
# Test HTTPS through nginx (no -k flag — certificate must be trusted)

echo "=== HTTPS Test ==="
echo ""

echo "--- app.team1.test ---"
/usr/bin/curl -v https://app.team1.test/api/status
echo ""
echo ""

echo "--- api.team1.test ---"
/usr/bin/curl -v https://api.team1.test/api/status
echo ""
