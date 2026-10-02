#!/bin/bash
# Test backends directly via LAN IP (bypass nginx)

echo "=== Direct Backend Tests ==="
echo ""

echo "--- Backend A (Mac 3 — 10.7.26.81:3001) ---"
curl -i http://10.7.26.81:3001/api/status
echo ""
echo ""

echo "--- Backend B (Mac 4 — 10.7.6.162:3002) ---"
curl -i http://10.7.6.162:3002/api/status
echo ""
