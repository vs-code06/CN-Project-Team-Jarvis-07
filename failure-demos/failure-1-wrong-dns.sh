#!/bin/bash
# FAILURE DEMO 1: Wrong DNS Server on Client
#
# This script demonstrates what happens when the client
# is configured to use a public DNS server (8.8.8.8) instead
# of the Team1 private DNS server (10.7.12.6).
#
# WHAT HAPPENS:
#   - app.team1.test is a private domain, not registered publicly
#   - Google's DNS (8.8.8.8) has no record for it
#   - dig returns NXDOMAIN or empty response
#   - curl/browser cannot connect
#   - BUT direct IP access still works (DNS is the only broken layer)
#
# HOW TO DEMONSTRATE:
#   1. Change client DNS to 8.8.8.8
#   2. Show that DNS resolution fails
#   3. Show that direct IP still works
#   4. Restore DNS to 10.7.12.6
#
# DO NOT RUN THIS SCRIPT BLINDLY — it changes your DNS settings.

echo "=== FAILURE DEMO 1: Wrong DNS Server ==="
echo ""

echo "Step 1: Change DNS to Google (8.8.8.8)"
echo "  sudo networksetup -setdnsservers Wi-Fi 8.8.8.8"
echo "  sudo dscacheutil -flushcache"
echo "  sudo killall -HUP mDNSResponder"
echo ""

echo "Step 2: Attempt DNS resolution (should FAIL)"
echo "  dig app.team1.test"
echo "  Expected: NXDOMAIN or no answer"
echo ""

echo "Step 3: Direct IP still works (DNS is bypassed)"
echo "  ping -c 3 10.7.3.73"
echo "  Expected: replies from 10.7.3.73"
echo ""

echo "Step 4: RESTORE — set DNS back to Team1 server"
echo "  sudo networksetup -setdnsservers Wi-Fi 10.7.12.6"
echo "  sudo dscacheutil -flushcache"
echo "  sudo killall -HUP mDNSResponder"
echo ""

echo "Step 5: Verify restoration"
echo "  dig app.team1.test"
echo "  Expected: 10.7.3.73"
