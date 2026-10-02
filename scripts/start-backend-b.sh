#!/bin/bash
# Start Backend B on Mac 4 (10.7.6.162)
cd "$(dirname "$0")/../backend"
node server.js B 3002
