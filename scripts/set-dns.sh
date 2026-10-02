#!/bin/bash
# Set or reset the DNS server on macOS
#
# Usage:
#   ./set-dns.sh 10.7.12.6    # Use Team Jarvis 07 private DNS (Mac 1)
#   ./set-dns.sh empty         # Restore default DNS (DHCP)

SERVICE="Wi-Fi"

sudo networksetup -setdnsservers "$SERVICE" "$1"

sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

networksetup -getdnsservers "$SERVICE"
