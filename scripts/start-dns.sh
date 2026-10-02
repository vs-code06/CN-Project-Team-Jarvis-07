#!/bin/bash
# Start dnsmasq on Mac 1 (10.7.12.6)
# Requires dnsmasq to be installed: brew install dnsmasq

# Stop any existing dnsmasq instance
sudo brew services stop dnsmasq 2>/dev/null

# Copy configuration
sudo cp "$(dirname "$0")/../config/dnsmasq.conf" /usr/local/etc/dnsmasq.conf

# Start dnsmasq
sudo brew services start dnsmasq

echo "dnsmasq started on Mac 1 (10.7.12.6:53)"
echo ""
echo "Verify with:"
echo "  dig @10.7.12.6 app.team1.test"
echo "  dig @10.7.12.6 api.team1.test"
