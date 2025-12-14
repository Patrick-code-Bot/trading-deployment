# Git Repository Management Guide

Managing multiple trading strategies with Docker orchestration across GitHub repositories.

---

## 🏗️ Repository Architecture

### Recommended: Three-Repository Strategy

```
┌─────────────────────────────────────────────────────────┐
│                      GitHub                             │
│                                                         │
│  ┌──────────────────────────────────────────┐         │
│  │  nautilus_AItrader.git                   │         │
│  │  - Strategy code                         │         │
│  │  - Dockerfile                            │         │
│  │  - .env.template                         │         │
│  │  - Independent version control           │         │
│  └──────────────────────────────────────────┘         │
│                                                         │
│  ┌──────────────────────────────────────────┐         │
│  │  GoldArb.git                              │         │
│  │  - Strategy code                         │         │
│  │  - Dockerfile                            │         │
│  │  - .env.example                          │         │
│  │  - Independent version control           │         │
│  └──────────────────────────────────────────┘         │
│                                                         │
│  ┌──────────────────────────────────────────┐         │
│  │  trading-deployment.git (NEW)            │         │
│  │  - docker-compose.yml                    │         │
│  │  - DOCKER_DEPLOYMENT.md                  │         │
│  │  - docker-start.sh                       │         │
│  │  - README.md with setup instructions     │         │
│  └──────────────────────────────────────────┘         │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 📁 Local Directory Structure

```
Project25/
├── .git/                       # Deployment repo
├── docker-compose.yml          # Orchestration
├── docker-start.sh             # Setup script
├── DOCKER_DEPLOYMENT.md        # Docs
│
├── nautilus_AItrader/
│   ├── .git/                   # → nautilus_AItrader.git
│   ├── Dockerfile              # ✓ Push to repo
│   ├── .dockerignore           # ✓ Push to repo
│   ├── .env                    # ✗ Never push
│   └── strategy/
│
└── GoldArb/
    ├── .git/                   # → GoldArb.git
    ├── Dockerfile              # ✓ Push to repo
    ├── .dockerignore           # ✓ Push to repo
    ├── .env                    # ✗ Never push
    └── paxg_xaut_grid_strategy.py
```

---

## 🚀 Quick Start

### Automated Setup

```bash
# Run the automated script
./setup-git-repos.sh
```

This will:
1. ✓ Push Docker files to nautilus_AItrader
2. ✓ Push Docker files to GoldArb
3. ✓ Initialize deployment repo (optional)

---

## 📝 Manual Setup (Step-by-Step)

### Step 1: Push nautilus_AItrader Updates

```bash
cd nautilus_AItrader

# Check status
git status

# Add Docker files
git add Dockerfile .dockerignore

# Commit
git commit -m "Add Docker support with multi-stage build

- Add production-ready Dockerfile
- Add .dockerignore for build optimization
- Support for non-root user execution
- Include health checks"

# Push to GitHub
git push origin main
```

### Step 2: Push GoldArb Updates

```bash
cd ../GoldArb

# Check status
git status

# Add Docker files
git add Dockerfile .dockerignore

# Optional: Add .env if it's .gitignore'd (recommended)
# git add .env  # Only if you want to push it (NOT recommended)

# Commit
git commit -m "Add Docker support with multi-stage build

- Add production-ready Dockerfile
- Add .dockerignore for build optimization
- Support for non-root user execution
- Include health checks"

# Push to GitHub
git push origin main
```

### Step 3: Create Deployment Repository

#### Option A: New Repository (Recommended)

```bash
cd /Users/patrick/Project25

# Initialize git (if not already done)
git init

# Add deployment files
git add docker-compose.yml
git add docker-start.sh
git add DOCKER_DEPLOYMENT.md
git add DOCKER_QUICKREF.md
git add GIT_REPOSITORY_GUIDE.md
git add setup-git-repos.sh

# Create .gitignore
cat > .gitignore << 'EOF'
# Environment files (NEVER commit API keys)
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
nautilus_AItrader/logs/
GoldArb/logs/

# Data
data/
nautilus_AItrader/data/
GoldArb/data/

# Python cache
__pycache__/
*.pyc

# Ignore strategy .git directories (they're separate repos)
nautilus_AItrader/.git/
GoldArb/.git/
EOF

git add .gitignore

# Commit
git commit -m "Initial commit: Docker orchestration for trading strategies

- Add docker-compose.yml for multi-strategy deployment
- Include Redis and PostgreSQL services
- Add comprehensive documentation
- Include automated setup scripts"

# Create repo on GitHub first, then:
git remote add origin https://github.com/Patrick-code-Bot/trading-deployment.git
git branch -M main
git push -u origin main
```

---

## 🔄 Day-to-Day Workflow

### Update Strategy Code

#### For nautilus_AItrader:

```bash
cd nautilus_AItrader

# Make changes to strategy
nano strategy/deepseek_strategy.py

# Commit and push
git add .
git commit -m "Update signal generation logic"
git push origin main

# Rebuild and restart Docker container
cd ..
docker compose up -d --build aitrader
```

#### For GoldArb:

```bash
cd GoldArb

# Make changes to strategy
nano paxg_xaut_grid_strategy.py

# Commit and push
git add .
git commit -m "Adjust grid parameters"
git push origin main

# Rebuild and restart Docker container
cd ..
docker compose up -d --build goldarb
```

### Update Docker Configuration

```bash
# In project root
nano docker-compose.yml

git add docker-compose.yml
git commit -m "Update resource limits"
git push origin main

# Restart with new configuration
docker compose down
docker compose up -d
```

---

## 🌲 Alternative: Git Submodules Approach

If you prefer to track strategy versions in the deployment repo:

### Initial Setup

```bash
cd /Users/patrick/Project25
git init

# Add strategies as submodules
git submodule add https://github.com/Patrick-code-Bot/nautilus_AItrader.git nautilus_AItrader
git submodule add https://github.com/Patrick-code-Bot/GoldArb.git

# Add deployment files
git add docker-compose.yml docker-start.sh *.md
git commit -m "Add deployment infrastructure with strategy submodules"

# Push to GitHub
git remote add origin https://github.com/Patrick-code-Bot/trading-deployment.git
git push -u origin main
```

### Cloning with Submodules

```bash
# New server/machine
git clone --recursive https://github.com/Patrick-code-Bot/trading-deployment.git
cd trading-deployment

# If you forgot --recursive
git submodule update --init --recursive
```

### Updating Submodules

```bash
# Update all submodules to latest
git submodule update --remote

# Or update specific submodule
cd nautilus_AItrader
git pull origin main
cd ..

# Commit submodule reference update
git add nautilus_AItrader
git commit -m "Update nautilus_AItrader to latest"
git push
```

---

## 📦 Deployment Scenarios

### Scenario 1: Deploy on New Server

#### Using Three-Repo Approach:

```bash
# 1. Clone deployment repo
git clone https://github.com/Patrick-code-Bot/trading-deployment.git
cd trading-deployment

# 2. Clone strategies
git clone https://github.com/Patrick-code-Bot/nautilus_AItrader.git
git clone https://github.com/Patrick-code-Bot/GoldArb.git

# 3. Configure environment
cp nautilus_AItrader/.env.template nautilus_AItrader/.env
cp GoldArb/.env.example GoldArb/.env

# Edit with API keys
nano nautilus_AItrader/.env
nano GoldArb/.env

# 4. Start services
docker compose up -d
```

#### Using Submodules:

```bash
# 1. Clone with submodules
git clone --recursive https://github.com/Patrick-code-Bot/trading-deployment.git
cd trading-deployment

# 2. Configure environment
cp nautilus_AItrader/.env.template nautilus_AItrader/.env
cp GoldArb/.env.example GoldArb/.env

# Edit with API keys
nano nautilus_AItrader/.env
nano GoldArb/.env

# 3. Start services
docker compose up -d
```

### Scenario 2: Update Strategy on Production

```bash
# SSH to server
ssh user@production-server

cd trading-deployment

# Pull strategy updates
cd nautilus_AItrader
git pull origin main
cd ..

# Rebuild and restart
docker compose up -d --build aitrader

# Monitor logs
docker compose logs -f aitrader
```

---

## 🔐 Security Best Practices

### Never Commit Sensitive Data

```bash
# Ensure .env is in .gitignore
echo ".env" >> .gitignore
echo "*.env" >> .gitignore

# Check what will be committed
git status

# Verify .env is ignored
git check-ignore nautilus_AItrader/.env
# Should output: nautilus_AItrader/.env
```

### Remove Accidentally Committed Secrets

```bash
# If you accidentally committed .env with API keys
git rm --cached nautilus_AItrader/.env
git commit -m "Remove .env from tracking"
git push origin main

# Then immediately rotate your API keys on the exchange!
```

### Use Environment Templates

```bash
# Each repo should have:
# - .env.template (committed) - shows required variables
# - .env (gitignored) - contains actual secrets

# Example .env.template:
cat > nautilus_AItrader/.env.template << 'EOF'
# Exchange API Keys
BINANCE_API_KEY=your_api_key_here
BINANCE_API_SECRET=your_api_secret_here

# AI Service
DEEPSEEK_API_KEY=your_deepseek_key_here
EOF

git add nautilus_AItrader/.env.template
git commit -m "Add environment template"
```

---

## 🛠️ Helper Scripts

### Update All Repositories

Create `update-all.sh`:

```bash
#!/bin/bash
echo "Updating all repositories..."

# Update nautilus_AItrader
cd nautilus_AItrader
echo "→ Updating nautilus_AItrader"
git pull origin main
cd ..

# Update GoldArb
cd GoldArb
echo "→ Updating GoldArb"
git pull origin main
cd ..

# Update deployment repo
echo "→ Updating deployment repo"
git pull origin main

echo "✓ All repositories updated"
```

### Push All Repositories

Create `push-all.sh`:

```bash
#!/bin/bash
read -p "Commit message: " msg

# Push nautilus_AItrader
cd nautilus_AItrader
if [[ -n $(git status -s) ]]; then
    git add .
    git commit -m "$msg"
    git push origin main
fi
cd ..

# Push GoldArb
cd GoldArb
if [[ -n $(git status -s) ]]; then
    git add .
    git commit -m "$msg"
    git push origin main
fi
cd ..

# Push deployment repo
if [[ -n $(git status -s) ]]; then
    git add .
    git commit -m "$msg"
    git push origin main
fi

echo "✓ All changes pushed"
```

Make executable:
```bash
chmod +x update-all.sh push-all.sh
```

---

## 📊 Repository Comparison

| Aspect | Separate Repos | Monorepo | Submodules |
|--------|---------------|----------|------------|
| **Setup complexity** | Medium | Low | High |
| **Independent versions** | ✓ Yes | ✗ No | ✓ Yes |
| **Single push** | ✗ No | ✓ Yes | ✗ No |
| **Share strategies** | ✓ Easy | ✗ Hard | ✓ Easy |
| **CI/CD** | ✓ Per strategy | One pipeline | ✓ Per strategy |
| **Learning curve** | Low | Low | High |
| **Recommended for** | Teams | Solo, private | Advanced users |

---

## ✅ Recommended Workflow

For your use case (two separate strategies on GitHub), I recommend:

**Three-Repository Approach:**

```
1. nautilus_AItrader.git - Strategy 1 (independent)
2. GoldArb.git - Strategy 2 (independent)
3. trading-deployment.git - Docker orchestration (shared)
```

**Workflow:**

```bash
# When updating a strategy:
cd nautilus_AItrader
# make changes
git push origin main

# When updating deployment:
cd /Users/patrick/Project25
# update docker-compose.yml
git push origin main

# On production:
git pull
docker compose up -d --build
```

---

## 🎯 Quick Commands Reference

```bash
# Push strategy updates
cd nautilus_AItrader && git add . && git commit -m "Update" && git push
cd GoldArb && git add . && git commit -m "Update" && git push

# Push deployment updates
cd /Users/patrick/Project25
git add docker-compose.yml && git commit -m "Update config" && git push

# Update on server
ssh server "cd trading-deployment && git pull && docker compose up -d --build"

# Clone everything fresh
git clone https://github.com/Patrick-code-Bot/trading-deployment.git
cd trading-deployment
git clone https://github.com/Patrick-code-Bot/nautilus_AItrader.git
git clone https://github.com/Patrick-code-Bot/GoldArb.git
```

---

## 📚 Additional Resources

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Guides](https://guides.github.com/)
- [Git Submodules Tutorial](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [Docker Compose Docs](https://docs.docker.com/compose/)

---

**Last Updated:** 2024-12-14
**Version:** 1.0.0
