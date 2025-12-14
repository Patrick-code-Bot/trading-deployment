#!/bin/bash
# ============================================================================
# Push Deployment Repository to GitHub
# ============================================================================
# Non-interactive version for direct execution
# ============================================================================

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}Pushing trading-deployment to GitHub${NC}"
echo -e "${BLUE}============================================================${NC}\n"

# Navigate to project directory
cd "$(dirname "$0")"

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo -e "${BLUE}Step 1: Initialize Git${NC}"
    git init
    echo -e "${GREEN}✓ Git initialized${NC}\n"
fi

# Stage files
echo -e "${BLUE}Step 2: Stage Files${NC}"
git add docker-compose.yml
git add docker-start.sh
git add init-deployment-repo.sh
git add setup-git-repos.sh
git add push-to-github.sh
git add README.md
git add DOCKER_DEPLOYMENT.md
git add DOCKER_QUICKREF.md
git add GIT_REPOSITORY_GUIDE.md
git add REPO_UPDATE_SUMMARY.md
git add verify-repo-changes.sh
git add .gitignore
git add .dockerignore
echo -e "${GREEN}✓ Files staged${NC}\n"

# Commit
echo -e "${BLUE}Step 3: Create Commit${NC}"
git commit -m "Initial commit: Docker orchestration for trading strategies

This repository contains the Docker infrastructure for deploying
multiple NautilusTrader algorithmic trading strategies.

Features:
- Multi-strategy deployment with docker-compose
- Redis for caching and messaging
- PostgreSQL for data persistence
- Resource limits and health checks
- Comprehensive documentation
- Automated setup scripts

Strategies:
- nautilus_AItrader: AI-powered strategy on Binance Futures
- GoldArb: Grid trading on Bybit (PAXG/XAUT)

Services:
- Trading strategy containers (isolated)
- Redis cache
- PostgreSQL database
- Private network
- Volume persistence

Documentation:
- README.md: Quick start guide
- DOCKER_DEPLOYMENT.md: Complete deployment guide (8000+ words)
- DOCKER_QUICKREF.md: Command reference
- GIT_REPOSITORY_GUIDE.md: Multi-repo management
- REPO_UPDATE_SUMMARY.md: Recent updates

Scripts:
- docker-start.sh: Interactive deployment wizard
- setup-git-repos.sh: Multi-repo management
- init-deployment-repo.sh: Repository initialization
- verify-repo-changes.sh: Verification utility
- push-to-github.sh: GitHub push automation"

echo -e "${GREEN}✓ Commit created${NC}\n"

# Add remote
echo -e "${BLUE}Step 4: Add Remote${NC}"
REMOTE_URL="https://github.com/Patrick-code-Bot/trading-deployment.git"

if git remote get-url origin 2>/dev/null; then
    echo "Remote already exists, updating..."
    git remote set-url origin "$REMOTE_URL"
else
    git remote add origin "$REMOTE_URL"
fi
echo -e "${GREEN}✓ Remote: $REMOTE_URL${NC}\n"

# Set branch to main
echo -e "${BLUE}Step 5: Set Branch to Main${NC}"
git branch -M main
echo -e "${GREEN}✓ Branch set to 'main'${NC}\n"

# Push
echo -e "${BLUE}Step 6: Push to GitHub${NC}"
echo -e "${YELLOW}Pushing to: $REMOTE_URL${NC}"
echo -e "${YELLOW}Branch: main${NC}\n"

if git push -u origin main; then
    echo ""
    echo -e "${GREEN}============================================================${NC}"
    echo -e "${GREEN}✓ Successfully pushed to GitHub!${NC}"
    echo -e "${GREEN}============================================================${NC}\n"

    echo "View your repository at:"
    echo "https://github.com/Patrick-code-Bot/trading-deployment"
    echo ""
    echo "Next steps:"
    echo "  1. Push nautilus_AItrader:"
    echo "     cd nautilus_AItrader && git add Dockerfile .dockerignore && git commit -m 'Add Docker support' && git push"
    echo ""
    echo "  2. Push GoldArb:"
    echo "     cd GoldArb && git add Dockerfile .dockerignore && git commit -m 'Add Docker support' && git push"
    echo ""
    echo "  3. Deploy on server:"
    echo "     git clone https://github.com/Patrick-code-Bot/trading-deployment.git"
    echo "     cd trading-deployment"
    echo "     git clone https://github.com/Patrick-code-Bot/nautilus_AItrader.git"
    echo "     git clone https://github.com/Patrick-code-Bot/GoldArb.git"
    echo "     ./docker-start.sh"
    echo ""
else
    echo ""
    echo -e "${YELLOW}============================================================${NC}"
    echo -e "${YELLOW}Push Failed${NC}"
    echo -e "${YELLOW}============================================================${NC}\n"

    echo "Common issues:"
    echo ""
    echo "1. Repository doesn't exist on GitHub"
    echo "   → Create it at: https://github.com/new"
    echo "   → Name: trading-deployment"
    echo "   → Visibility: Private"
    echo "   → Don't initialize with README"
    echo ""
    echo "2. Authentication failed"
    echo "   → Set up SSH key or use personal access token"
    echo "   → See: https://docs.github.com/en/authentication"
    echo ""
    echo "3. Branch already exists remotely"
    echo "   → Use: git push -f origin main (careful!)"
    echo ""
    exit 1
fi
