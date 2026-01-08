#!/bin/bash

# Backfill logs for past N days
# Usage: ./backfill.sh [days_back]

DAYS_BACK="${1:-30}"
SCRIPT_DIR="$(dirname "$0")"

echo "Backfilling last $DAYS_BACK days..."

for i in $(seq 0 $DAYS_BACK); do
    date=$(date -d "$i days ago" +%Y-%m-%d)
    "$SCRIPT_DIR/generate-log.sh" "$date"
done

echo "Done!"
