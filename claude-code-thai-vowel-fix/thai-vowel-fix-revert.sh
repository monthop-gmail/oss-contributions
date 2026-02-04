#!/bin/bash
#
# Revert Thai Vowel Fix for Claude Code
# ======================================
# Restores original behavior (for testing purposes)
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}====================================${NC}"
echo -e "${BLUE} Revert Thai Vowel Fix             ${NC}"
echo -e "${BLUE}====================================${NC}"
echo ""

# Find Claude Code installation
find_cli_js() {
    if command -v claude &> /dev/null; then
        local claude_bin=$(which claude)
        local claude_dir=$(dirname $(dirname "$claude_bin"))
        local cli_path="$claude_dir/lib/node_modules/@anthropic-ai/claude-code/cli.js"
        if [[ -f "$cli_path" ]]; then
            echo "$cli_path"
            return 0
        fi
    fi

    local paths=(
        "$HOME/.nvm/versions/node/*/lib/node_modules/@anthropic-ai/claude-code/cli.js"
        "/usr/local/lib/node_modules/@anthropic-ai/claude-code/cli.js"
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

CLI_JS=$(find_cli_js) || {
    echo -e "${RED}Error: Could not find Claude Code cli.js${NC}"
    exit 1
}

echo -e "Found cli.js: ${GREEN}$CLI_JS${NC}"

# Check if fix is applied
if ! grep -q 'A===3633||A>=3636&&A<=3642' "$CLI_JS" 2>/dev/null; then
    echo ""
    echo -e "${YELLOW}Fix is not currently applied.${NC}"
    exit 0
fi

# Revert
echo ""
echo "Reverting fix..."
sed -i 's/A===3633||A>=3636&&A<=3642/A>=3633\&\&A<=3642/g' "$CLI_JS"

if grep -q 'A>=3633&&A<=3642' "$CLI_JS" 2>/dev/null; then
    echo -e "${GREEN}Successfully reverted to original.${NC}"
else
    echo -e "${RED}Error: Revert failed${NC}"
    exit 1
fi
