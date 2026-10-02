#!/bin/bash
# FAILURE DEMO 5: Correct Hostname, Wrong HTTPS Port
#
# This demonstrates what happens when the client uses the correct
# hostname but connects to a port where nothing is listening.
#
# nginx listens on port 443. Port 8444 is not open on Mac 2.
#
# WHAT HAPPENS:
#   - DNS resolves correctly to 10.7.3.73
#   - TCP connection to port 8444 is REFUSED
#   - No TLS handshake occurs
#   - curl reports "connection refused"
#   - But ping still works (ICMP doesn't use TCP ports)
#
# NO RESTORATION NEEDED — this test does not change any configuration.

echo "=== FAILURE DEMO 5: Wrong HTTPS Port ==="
echo ""

echo "Step 1: Attempt HTTPS on wrong port"
echo "  /usr/bin/curl -v https://app.team1.test:8444/"
echo "  Expected: connection refused"
echo ""

echo "Step 2: Verify that the host is reachable (ICMP)"
echo "  ping -c 3 10.7.3.73"
echo "  Expected: replies from 10.7.3.73"
echo ""

echo "Step 3: Confirm correct port works"
echo "  /usr/bin/curl -v https://app.team1.test/api/status"
echo "  Expected: 200 OK (port 443)"
