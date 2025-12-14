#!/bin/bash
# ============================================================================
# Initialize trading-deployment Git Repository
# ============================================================================
# This script initializes the deployment repository and pushes to GitHub
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}============================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Change to script directory
cd "$(dirname "$0")"

print_header "Initialize trading-deployment Repository"

# Step 1: Check if already initialized
if [ -d ".git" ]; then
    print_warning "Git repository already initialized"
    echo "Current remotes:"
    git remote -v
    echo ""
    read -p "Continue anyway? (yes/no): " continue_init
    if [ "$continue_init" != "yes" ]; then
        echo "Exiting..."
        exit 0
    fi
else
    print_header "Step 1: Initialize Git Repository"
    git init
    print_success "Git repository initialized"
fi

# Step 2: Check .gitignore
print_header "Step 2: Verify .gitignore"
if [ -f ".gitignore" ]; then
    print_success ".gitignore exists"
else
    print_error ".gitignore not found!"
    exit 1
fi

# Step 3: Stage files
print_header "Step 3: Staging Files"

echo "Files to be committed:"
echo "  - docker-compose.yml"
echo "  - docker-start.sh"
echo "  - init-deployment-repo.sh"
echo "  - setup-git-repos.sh"
echo "  - README.md"
echo "  - DOCKER_DEPLOYMENT.md"
echo "  - DOCKER_QUICKREF.md"
echo "  - GIT_REPOSITORY_GUIDE.md"
echo "  - .gitignore"
echo "  - .dockerignore"
echo ""

# Add files
git add docker-compose.yml
git add docker-start.sh
git add init-deployment-repo.sh
git add setup-git-repos.sh
git add README.md
git add DOCKER_DEPLOYMENT.md
git add DOCKER_QUICKREF.md
git add GIT_REPOSITORY_GUIDE.md
git add .gitignore
git add .dockerignore

print_success "Files staged"

# Step 4: Show what will be committed
print_header "Step 4: Review Changes"
git status
echo ""

read -p "Proceed with commit? (yes/no): " proceed_commit
if [ "$proceed_commit" != "yes" ]; then
    print_warning "Commit cancelled"
    exit 0
fi

# Step 5: Commit
print_header "Step 5: Creating Initial Commit"

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
- Trading strategy containers
- Redis (cache)
- PostgreSQL (database)
- Isolated network
- Volume persistence

Documentation:
- README.md: Quick start guide
- DOCKER_DEPLOYMENT.md: Complete deployment guide
- DOCKER_QUICKREF.md: Command reference
- GIT_REPOSITORY_GUIDE.md: Repository management

Scripts:
- docker-start.sh: Interactive deployment
- setup-git-repos.sh: Multi-repo management
- init-deployment-repo.sh: Repository initialization"

print_success "Initial commit created"

# Step 6: Check remote
print_header "Step 6: Configure Remote"

REMOTE_URL="https://github.com/Patrick-code-Bot/trading-deployment.git"

if git remote get-url origin 2>/dev/null; then
    print_warning "Remote 'origin' already exists:"
    git remote get-url origin
    echo ""
    read -p "Update to $REMOTE_URL? (yes/no): " update_remote
    if [ "$update_remote" = "yes" ]; then
        git remote set-url origin "$REMOTE_URL"
        print_success "Remote updated"
    fi
else
    git remote add origin "$REMOTE_URL"
    print_success "Remote 'origin' added: $REMOTE_URL"
fi

# Step 7: Set branch to main
print_header "Step 7: Set Main Branch"

git branch -M main
print_success "Branch set to 'main'"

# Step 8: Push to GitHub
print_header "Step 8: Push to GitHub"

echo "About to push to:"
echo "  Repository: $REMOTE_URL"
echo "  Branch: main"
echo ""
print_warning "Make sure you have created the repository on GitHub first!"
echo ""
echo "If not, visit: https://github.com/new"
echo "Repository name: trading-deployment"
echo "Visibility: Private (recommended)"
echo ""

read -p "Ready to push? (yes/no): " ready_push
if [ "$ready_push" != "yes" ]; then
    print_warning "Push cancelled"
    echo ""
    echo "When ready, run:"
    echo "  git push -u origin main"
    exit 0
fi

if git push -u origin main; then
    print_success "Successfully pushed to GitHub!"
else
    print_error "Push failed!"
    echo ""
    echo "Common issues:"
    echo "  1. Repository doesn't exist on GitHub"
    echo "     → Create it at: https://github.com/new"
    echo ""
    echo "  2. Authentication failed"
    echo "     → Set up SSH key or use personal access token"
    echo "     → See: https://docs.github.com/en/authentication"
    echo ""
    echo "  3. Branch already exists"
    echo "     → Use: git push -f origin main (careful!)"
    echo ""
    exit 1
fi

# Step 9: Summary
print_header "Setup Complete! 🎉"

echo "Your trading-deployment repository is ready!"
echo ""
echo "Repository: https://github.com/Patrick-code-Bot/trading-deployment"
echo ""
echo "What's next?"
echo ""
echo "1. Update strategy repositories:"
echo "   cd nautilus_AItrader"
echo "   git add Dockerfile .dockerignore"
echo "   git commit -m 'Add Docker support'"
echo "   git push origin main"
echo ""
echo "2. Do the same for GoldArb:"
echo "   cd GoldArb"
echo "   git add Dockerfile .dockerignore"
echo "   git commit -m 'Add Docker support'"
echo "   git push origin main"
echo ""
echo "3. Deploy on a server:"
echo "   git clone https://github.com/Patrick-code-Bot/trading-deployment.git"
echo "   cd trading-deployment"
echo "   git clone https://github.com/Patrick-code-Bot/nautilus_AItrader.git"
echo "   git clone https://github.com/Patrick-code-Bot/GoldArb.git"
echo "   ./docker-start.sh"
echo ""

print_success "All done!"
