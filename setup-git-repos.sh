#!/bin/bash
# ============================================================================
# Git Repository Setup Script
# ============================================================================
# This script helps you push Docker changes to existing repositories and
# create a new deployment repository for shared files.
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

# Main script
print_header "Git Repository Setup - Three Repository Strategy"

echo "This script will:"
echo "  1. Push Docker files to nautilus_AItrader repo"
echo "  2. Push Docker files to GoldArb repo"
echo "  3. Create a deployment repo for docker-compose.yml"
echo ""

read -p "Continue? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    exit 0
fi

# ============================================================================
# Step 1: Push nautilus_AItrader
# ============================================================================
print_header "Step 1: Pushing nautilus_AItrader"

cd nautilus_AItrader

# Check for uncommitted changes
if [[ -n $(git status -s) ]]; then
    print_warning "Uncommitted changes found"

    git add Dockerfile .dockerignore

    echo "Commit message (or press Enter for default):"
    read commit_msg
    if [ -z "$commit_msg" ]; then
        commit_msg="Add Docker support with multi-stage build"
    fi

    git commit -m "$commit_msg"
    print_success "Changes committed"
else
    print_success "No changes to commit"
fi

# Push to remote
echo "Pushing to GitHub..."
if git push origin main; then
    print_success "nautilus_AItrader pushed successfully"
else
    print_error "Failed to push. Trying 'master' branch..."
    git push origin master || print_error "Push failed"
fi

cd ..

# ============================================================================
# Step 2: Push GoldArb
# ============================================================================
print_header "Step 2: Pushing GoldArb"

cd GoldArb

# Check for uncommitted changes
if [[ -n $(git status -s) ]]; then
    print_warning "Uncommitted changes found"

    git add Dockerfile .dockerignore .env

    echo "Commit message (or press Enter for default):"
    read commit_msg
    if [ -z "$commit_msg" ]; then
        commit_msg="Add Docker support with multi-stage build"
    fi

    git commit -m "$commit_msg"
    print_success "Changes committed"
else
    print_success "No changes to commit"
fi

# Push to remote
echo "Pushing to GitHub..."
if git push origin main; then
    print_success "GoldArb pushed successfully"
else
    print_error "Failed to push. Trying 'master' branch..."
    git push origin master || print_error "Push failed"
fi

cd ..

# ============================================================================
# Step 3: Create deployment repo (optional)
# ============================================================================
print_header "Step 3: Create Deployment Repository (Optional)"

echo "This will create a new repo for docker-compose.yml and deployment scripts."
echo ""
read -p "Create deployment repo? (yes/no): " create_deploy

if [ "$create_deploy" = "yes" ]; then

    # Check if already initialized
    if [ -d ".git" ]; then
        print_warning "Root directory already has .git"
        print_warning "Using existing repository"
    else
        print_warning "Initializing new git repository"
        git init
    fi

    # Create .gitignore
    cat > .gitignore << 'EOF'
# Environment files
.env
*.env
!.env.example
!.env.template

# OS files
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/

# Logs
*.log
logs/

# Data
data/
*.db

# Python
__pycache__/
*.pyc

# Strategy subdirectories (they have their own repos)
# Comment these out if not using separate repos
nautilus_AItrader/.git
GoldArb/.git
EOF

    # Add files
    git add docker-compose.yml
    git add docker-start.sh
    git add DOCKER_DEPLOYMENT.md
    git add DOCKER_QUICKREF.md
    git add .gitignore
    git add .dockerignore

    # Commit
    git commit -m "Add Docker orchestration for trading strategies"

    print_success "Deployment repo initialized locally"
    echo ""
    echo "Next steps:"
    echo "  1. Create a new repo on GitHub: https://github.com/new"
    echo "     Suggested name: 'trading-deployment'"
    echo ""
    echo "  2. Then run:"
    echo "     git remote add origin https://github.com/Patrick-code-Bot/trading-deployment.git"
    echo "     git branch -M main"
    echo "     git push -u origin main"

else
    print_warning "Skipping deployment repo creation"
fi

# ============================================================================
# Summary
# ============================================================================
print_header "Summary"

echo "Repository Status:"
echo ""
echo "1. nautilus_AItrader:"
echo "   GitHub: https://github.com/Patrick-code-Bot/nautilus_AItrader"
echo "   Status: ✓ Updated with Docker support"
echo ""
echo "2. GoldArb:"
echo "   GitHub: https://github.com/Patrick-code-Bot/GoldArb"
echo "   Status: ✓ Updated with Docker support"
echo ""

if [ "$create_deploy" = "yes" ]; then
    echo "3. Deployment repo:"
    echo "   Status: ⚠ Created locally, needs GitHub repo"
    echo "   Action: Create repo on GitHub and push"
fi

echo ""
print_success "Setup complete!"
