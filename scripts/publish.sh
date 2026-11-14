#!/usr/bin/env bash
# Copy finished notes from the Obsidian vault into this repo and push.
# Usage: scripts/publish.sh ["commit message"]
# The vault location comes from $VAULT (default ~/Vault).
# inbox/, daily/, templates/ and archive/ are never copied.

set -euo pipefail

VAULT="${VAULT:-$HOME/Vault}"
REPO="$(cd "$(dirname "$0")/.." && pwd -P)"
MESSAGE="${1:-update notes}"

if [ ! -d "$VAULT" ]; then
    echo "error: vault not found at $VAULT (set VAULT=/path/to/vault)" >&2
    exit 1
fi

for d in mocs literature permanent projects pointers; do
    [ -d "$VAULT/$d" ] || continue
    # index.md in each content folder belongs to the repo, so --delete leaves it alone.
    rsync -a --delete --exclude 'index.md' --exclude '*.pdf' --exclude '.DS_Store' \
        "$VAULT/$d/" "$REPO/content/$d/"
done

cd "$REPO"
git add -A content
if git diff --cached --quiet; then
    echo "nothing to publish"
    exit 0
fi
git diff --cached --stat
git commit -m "$MESSAGE"
git push
