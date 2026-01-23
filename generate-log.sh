#!/bin/bash

# Vibecoding Daily Log Generator
# Creates fresh WORK_LOGS for today, archives yesterday

VIBECODING_DIR="/home/adam-koszalka/ŻYCIE/VIBECODING"
LOGGER_DIR="$VIBECODING_DIR/vibecoding-logger"
WORK_LOGS="$LOGGER_DIR/WORK_LOGS"
ARCHIVE_DIR="$LOGGER_DIR/archive"
GIT_EMAIL="hamper100@gmail.com"

TODAY=$(date +%Y-%m-%d)
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)

# Create archive dir if needed
mkdir -p "$ARCHIVE_DIR"

# Archive yesterday's log if WORK_LOGS exists and is from a previous day
if [ -f "$WORK_LOGS" ]; then
    LOG_DATE=$(head -1 "$WORK_LOGS" | grep -oP '\d{4}-\d{2}-\d{2}' || echo "")
    if [ -n "$LOG_DATE" ] && [ "$LOG_DATE" != "$TODAY" ]; then
        mv "$WORK_LOGS" "$ARCHIVE_DIR/$LOG_DATE.md"
        echo "Archived: $LOG_DATE.md"
    fi
fi

# Find all git repos in VIBECODING and PRACA
PRACA_DIR="/home/adam-koszalka/ŻYCIE/PRACA"
find_repos() {
    {
        find "$VIBECODING_DIR" -maxdepth 3 -type d -name ".git" 2>/dev/null
        find "$PRACA_DIR" -maxdepth 3 -type d -name ".git" 2>/dev/null
    } | sed 's/\/.git$//'
}

# Get commits for today
get_commits() {
    local repo="$1"
    cd "$repo" 2>/dev/null || return
    git log --author="$GIT_EMAIL" --after="$TODAY 00:00:00" --before="$TODAY 23:59:59" \
        --pretty=format:"%h|%s" 2>/dev/null
}

count_commits() {
    local repo="$1"
    cd "$repo" 2>/dev/null || return
    git log --author="$GIT_EMAIL" --after="$TODAY 00:00:00" --before="$TODAY 23:59:59" \
        --oneline 2>/dev/null | wc -l
}

# Generate today's log
generate_log() {
    local total_commits=0
    local active_projects=0
    local commit_section=""
    local project_list=""

    while IFS= read -r repo; do
        local repo_name=$(basename "$repo")
        local commit_count=$(count_commits "$repo")

        if [ "$commit_count" -gt 0 ]; then
            total_commits=$((total_commits + commit_count))
            active_projects=$((active_projects + 1))
            project_list+="$repo_name, "
            commit_section+="### $repo_name ($commit_count)\n"

            while IFS='|' read -r hash msg; do
                if [ -n "$hash" ]; then
                    commit_section+="- [$hash] $msg\n"
                fi
            done <<< "$(get_commits "$repo")"
            commit_section+="\n"
        fi
    done <<< "$(find_repos)"

    # Remove trailing comma from project list
    project_list=${project_list%, }

    # Create fresh WORK_LOGS
    cat > "$WORK_LOGS" << EOF
# WORK LOG - $TODAY

## Today's Summary
- $total_commits commits across $active_projects projects
- (Claude fills this at end of session)

---

## Commits ($total_commits)

$(echo -e "$commit_section")
## Progress


---

## Stats

| Metric | Value |
|--------|-------|
| Commits | $total_commits |
| Projects | $active_projects |
| Repos | $project_list |
EOF

    echo "Generated WORK_LOGS for $TODAY ($total_commits commits)"
}

generate_log
