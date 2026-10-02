#!/bin/bash
# Test HTTP caching behavior (Cache-Control, ETag, 304 Not Modified)

echo "=== Cache Test ==="
echo ""

echo "--- Step 1: Initial request (expect 200 + ETag) ---"
/usr/bin/curl -sI https://app.team1.test/api/cached
echo ""

echo "--- Step 2: Capture the ETag ---"
ETAG=$(/usr/bin/curl -sI https://app.team1.test/api/cached | grep -i "ETag" | tr -d '\r')
echo "Captured: $ETAG"
echo ""

# Extract just the ETag value
ETAG_VALUE=$(echo "$ETAG" | sed 's/[Ee][Tt][Aa][Gg]: //')

echo "--- Step 3: Conditional request with If-None-Match (expect 304) ---"
/usr/bin/curl -i -H "If-None-Match: $ETAG_VALUE" https://app.team1.test/api/cached
echo ""
