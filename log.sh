#!/bin/bash

# Quick progress logger
# Usage: log "description of what was done"

WORK_LOGS="/home/adam-koszalka/ŻYCIE/VIBECODING/vibecoding-logger/WORK_LOGS"
TIME=$(date +%H:%M)

if [ -z "$1" ]; then
    echo "Usage: log \"what you worked on\""
    exit 1
fi

MESSAGE="$*"
ENTRY="- **$TIME** $MESSAGE"

# Insert into Progress section (before the "---" after Progress)
if grep -q "^## Progress" "$WORK_LOGS"; then
    sed -i "/^## Progress/,/^---/{
        /^---/i\\
$ENTRY\\

    }" "$WORK_LOGS"
else
    # Fallback: append to end if no Progress section
    echo "$ENTRY" >> "$WORK_LOGS"
fi

echo "Logged: $MESSAGE"
