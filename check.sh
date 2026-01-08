#!/bin/bash

# Check for uncommitted work across all VIBECODING projects
# Run at end of session to ensure nothing was forgotten

VIBECODING_DIR="/home/adam-koszalka/ŻYCIE/VIBECODING"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Checking for uncommitted work..."
echo ""

has_uncommitted=false

# Find all git repos
while IFS= read -r repo; do
    repo_name=$(basename "$repo")
    cd "$repo" 2>/dev/null || continue

    # Check for changes
    staged=$(git diff --cached --name-only 2>/dev/null | wc -l)
    unstaged=$(git diff --name-only 2>/dev/null | wc -l)
    untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)

    total=$((staged + unstaged + untracked))

    if [ "$total" -gt 0 ]; then
        has_uncommitted=true
        echo -e "${YELLOW}$repo_name${NC} - $total uncommitted changes:"

        if [ "$staged" -gt 0 ]; then
            echo -e "  ${GREEN}Staged:${NC} $staged files"
        fi
        if [ "$unstaged" -gt 0 ]; then
            echo -e "  ${RED}Modified:${NC} $unstaged files"
            git diff --name-only 2>/dev/null | sed 's/^/    /'
        fi
        if [ "$untracked" -gt 0 ]; then
            echo -e "  ${RED}Untracked:${NC} $untracked files"
            git ls-files --others --exclude-standard 2>/dev/null | sed 's/^/    /'
        fi
        echo ""
    fi
done <<< "$(find "$VIBECODING_DIR" -maxdepth 3 -type d -name ".git" 2>/dev/null | sed 's/\/.git$//')"

if [ "$has_uncommitted" = false ]; then
    echo -e "${GREEN}All projects committed!${NC}"
else
    echo -e "${RED}Some work is not committed yet.${NC}"
    echo "Run 'git add . && git commit -m \"message\"' in each project."
fi
