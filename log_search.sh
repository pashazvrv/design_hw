#!/bin/bash
# скрипт 3

LOG_FILE="$1"
KEYWORD="$2"
OUT_FILE="found_${KEYWORD}.txt"

grep "$KEYWORD" "$LOG_FILE" > "$OUT_FILE"
COUNT=$(wc -l < "$OUT_FILE")

echo "found: $COUNT"
echo "written in: $OUT_FILE"
