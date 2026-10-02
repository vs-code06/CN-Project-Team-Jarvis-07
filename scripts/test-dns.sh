#!/bin/bash
# Test DNS resolution
# Run from any Mac with DNS set to 10.7.12.6

echo "=== DNS Resolution Test ==="
echo ""

echo "--- app.team1.test ---"
dig app.team1.test

echo ""
echo "--- api.team1.test ---"
dig api.team1.test

echo ""
echo "--- Direct query to DNS server ---"
dig @10.7.12.6 app.team1.test
dig @10.7.12.6 api.team1.test
