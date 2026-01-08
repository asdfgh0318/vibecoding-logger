#!/bin/bash

# Quick commit all uncommitted work with timestamp
# Use only for minor changes - prefer proper commit messages

VIBECODING_DIR="/home/adam-koszalka/ŻYCIE/VIBECODING"
TODAY=$(date +%Y-%m-%d)
TIME=$(date +%H:%M)

echo "Committing all uncommitted work..."

while IFS= read -r repo; do
    repo_name=$(basename "$repo")
    cd "$repo" 2>/dev/null || continue

    # Check if has changes
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
        echo ""
        echo "Committing: $repo_name"
        git add .
        git commit -m "WIP: $TODAY $TIME session work"
        echo "Done: $repo_name"
    fi
done <<< "$(find "$VIBECODING_DIR" -maxdepth 3 -type d -name ".git" 2>/dev/null | sed 's/\/.git$//')"

echo ""
echo "All done! Run ./generate-log.sh to update WORK_LOGS"
