#!/bin/bash
#
# Thai Vowel Fix for Claude Code
# ===============================
# Fixes display issue with Thai vowels า (U+0E32) and ำ (U+0E33)
#
# Problem: Claude Code treats these spacing vowels as zero-width combining marks
# Solution: Exclude code points 3634-3635 from the zero-width check
#
# GitHub Issue: https://github.com/anthropics/claude-code/issues/21149
# Author: monthop-gmail
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE} Thai Vowel Fix for Claude Code ${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Find Claude Code installation
find_cli_js() {
    local cli_path=""

    # Method 1: Use which claude
    if command -v claude &> /dev/null; then
        local claude_bin=$(which claude)
        local claude_dir=$(dirname $(dirname "$claude_bin"))
        cli_path="$claude_dir/lib/node_modules/@anthropic-ai/claude-code/cli.js"
        if [[ -f "$cli_path" ]]; then
            echo "$cli_path"
            return 0
        fi
    fi

    # Method 2: Check common npm global paths
    local paths=(
        "$HOME/.nvm/versions/node/*/lib/node_modules/@anthropic-ai/claude-code/cli.js"
        "/usr/local/lib/node_modules/@anthropic-ai/claude-code/cli.js"
        "/usr/lib/node_modules/@anthropic-ai/claude-code/cli.js"
        "$HOME/.npm-global/lib/node_modules/@anthropic-ai/claude-code/cli.js"
    )

    for pattern in "${paths[@]}"; do
        for path in $pattern; do
            if [[ -f "$path" ]]; then
                echo "$path"
                return 0
            fi
        done
    done

    return 1
}

# Main
CLI_JS=$(find_cli_js) || {
    echo -e "${RED}Error: Could not find Claude Code cli.js${NC}"
    echo "Make sure Claude Code is installed: npm install -g @anthropic-ai/claude-code"
    exit 1
}

echo -e "Found cli.js: ${GREEN}$CLI_JS${NC}"
echo ""

# Check Claude version
if command -v claude &> /dev/null; then
    VERSION=$(claude --version 2>/dev/null | head -1)
    echo -e "Claude Code version: ${YELLOW}$VERSION${NC}"
fi

# Check if fix is already applied
if grep -q 'A===3633||A>=3636&&A<=3642' "$CLI_JS" 2>/dev/null; then
    echo ""
    echo -e "${GREEN}Fix is already applied!${NC}"
    echo ""
    echo "Test by typing Thai text with า or ำ:"
    echo "  สวัสดีจ้า  น้ำ  ภาษาไทย"
    exit 0
fi

# Check if the pattern exists
if ! grep -q 'A>=3633&&A<=3642' "$CLI_JS" 2>/dev/null; then
    echo ""
    echo -e "${YELLOW}Warning: Expected pattern not found${NC}"
    echo "This might be a different version of Claude Code."
    echo "The fix may have already been applied officially."
    exit 1
fi

# Create backup
BACKUP_FILE="${CLI_JS}.backup.$(date +%Y%m%d%H%M%S)"
echo ""
echo -e "Creating backup: ${BLUE}$BACKUP_FILE${NC}"
cp "$CLI_JS" "$BACKUP_FILE"

# Apply fix
echo "Applying Thai vowel fix..."
sed -i 's/A>=3633&&A<=3642/A===3633||A>=3636\&\&A<=3642/g' "$CLI_JS"

# Verify fix
if grep -q 'A===3633||A>=3636&&A<=3642' "$CLI_JS" 2>/dev/null; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN} Fix applied successfully!              ${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "Changes made:"
    echo -e "  Before: ${RED}A>=3633&&A<=3642${NC}"
    echo -e "  After:  ${GREEN}A===3633||A>=3636&&A<=3642${NC}"
    echo ""
    echo "This excludes Thai vowels:"
    echo "  - 3634 (U+0E32) Sara Aa: า"
    echo "  - 3635 (U+0E33) Sara Am: ำ"
    echo ""
    echo -e "${YELLOW}Note: Run this script again after 'claude update'${NC}"
    echo ""
    echo "Test by typing Thai text:"
    echo "  สวัสดีจ้า  น้ำ  ภาษาไทย"
else
    echo -e "${RED}Error: Fix verification failed${NC}"
    echo "Restoring backup..."
    cp "$BACKUP_FILE" "$CLI_JS"
    exit 1
fi
