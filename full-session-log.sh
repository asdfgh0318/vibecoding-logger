#!/bin/bash

# Full session logger - preserves progress entries while refreshing commits
# Use this at end of Claude sessions

LOGGER_DIR="/home/adam-koszalka/ŻYCIE/VIBECODING/vibecoding-logger"
WORK_LOGS="$LOGGER_DIR/WORK_LOGS"
TEMP_PROGRESS="/tmp/vibelog_progress_$$"

# Save existing Progress entries if log exists and is from today
TODAY=$(date +%Y-%m-%d)
if [ -f "$WORK_LOGS" ]; then
    LOG_DATE=$(head -1 "$WORK_LOGS" | grep -oP '\d{4}-\d{2}-\d{2}' || echo "")
    if [ "$LOG_DATE" = "$TODAY" ]; then
        # Extract Progress section (between "## Progress" and next "---")
        sed -n '/^## Progress/,/^---/{/^## Progress/d;/^---/d;p}' "$WORK_LOGS" > "$TEMP_PROGRESS"
    fi
fi

# Regenerate log (captures new commits, archives if needed)
"$LOGGER_DIR/generate-log.sh"

# Restore Progress entries if we saved any
if [ -f "$TEMP_PROGRESS" ] && [ -s "$TEMP_PROGRESS" ]; then
    # Insert saved progress after "## Progress" line
    sed -i "/^## Progress/r $TEMP_PROGRESS" "$WORK_LOGS"
    rm -f "$TEMP_PROGRESS"
fi

# Add session marker
TIME=$(date +%H:%M)
INPUT=$(cat 2>/dev/null || echo "")
DIR=$(echo "$INPUT" | grep -oP '"cwd"\s*:\s*"\K[^"]+' 2>/dev/null | xargs basename 2>/dev/null)
if [ -z "$DIR" ]; then
    DIR=$(basename "$PWD")
fi

# Insert session marker into Progress section
ENTRY="- **$TIME** [session] worked in $DIR"
sed -i "/^## Progress/,/^---/{
    /^---/i\\
$ENTRY
}" "$WORK_LOGS"

echo "Full log updated for $TODAY"
