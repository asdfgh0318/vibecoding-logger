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

# Append to Progress section
echo "- **$TIME** $MESSAGE" >> "$WORK_LOGS"

echo "Logged: $MESSAGE"
