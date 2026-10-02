#!/bin/bash
# Start Backend A on Mac 3 (10.7.26.81)
cd "$(dirname "$0")/../backend"
node server.js A 3001
