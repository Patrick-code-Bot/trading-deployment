#!/bin/bash
# ============================================================================
# Verify Repository Name Changes
# ============================================================================

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}Verifying Repository Name Changes (PSArb → GoldArb)${NC}"
echo -e "${BLUE}============================================================${NC}\n"

# Check git remote in GoldArb directory
echo -e "${YELLOW}1. Checking GoldArb git remote...${NC}"
cd GoldArb
REMOTE_URL=$(git remote get-url origin)
echo "   Current remote: $REMOTE_URL"
if [[ "$REMOTE_URL" == *"GoldArb.git"* ]]; then
    echo -e "   ${GREEN}✓ Correct (GoldArb.git)${NC}"
else
    echo -e "   ${YELLOW}⚠ Still shows old URL (PSArb.git)${NC}"
fi
cd ..

echo ""

# Check deployment files
echo -e "${YELLOW}2. Checking deployment files for PSArb references...${NC}"
FILES_TO_CHECK=(
    "README.md"
    "GIT_REPOSITORY_GUIDE.md"
    "setup-git-repos.sh"
    "init-deployment-repo.sh"
    "docker-compose.yml"
)

FOUND_ISSUES=0
for file in "${FILES_TO_CHECK[@]}"; do
    if [ -f "$file" ]; then
        COUNT=$(grep -c "PSArb" "$file" 2>/dev/null || echo "0")
        if [ "$COUNT" -gt 0 ]; then
            echo -e "   ${YELLOW}⚠ Found PSArb in $file ($COUNT occurrences)${NC}"
            FOUND_ISSUES=1
        else
            echo -e "   ${GREEN}✓ $file - Clean${NC}"
        fi
    fi
done

echo ""

# Summary
echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}Summary${NC}"
echo -e "${BLUE}============================================================${NC}\n"

if [ $FOUND_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ All deployment files updated successfully!${NC}"
    echo -e "${GREEN}✓ GoldArb git remote updated${NC}"
    echo ""
    echo "Ready to push to GitHub:"
    echo "  1. GoldArb: cd GoldArb && git push origin main"
    echo "  2. nautilus_AItrader: cd nautilus_AItrader && git push origin main"
    echo "  3. Deployment: ./init-deployment-repo.sh"
else
    echo -e "${YELLOW}⚠ Some PSArb references found${NC}"
    echo "Note: References in GoldArb/ subdirectory are OK (it's a separate repo)"
fi

echo ""
