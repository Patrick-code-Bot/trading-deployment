# Docker Deployment Guide for Trading Strategies

Complete guide for deploying both `nautilus_AItrader` and `GoldArb` strategies using Docker Compose.

---

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Initial Setup](#initial-setup)
- [Configuration](#configuration)
- [Building and Running](#building-and-running)
- [Management Commands](#management-commands)
- [Monitoring and Logs](#monitoring-and-logs)
- [Troubleshooting](#troubleshooting)
- [Resource Management](#resource-management)
- [Security Best Practices](#security-best-practices)

---

## Prerequisites

### System Requirements

- **OS**: Linux, macOS, or Windows with WSL2
- **RAM**: Minimum 4GB (8GB+ recommended)
- **Disk**: 5GB free space
- **CPU**: 2+ cores recommended

### Software Requirements

1. **Docker Engine** (20.10+)
2. **Docker Compose** (2.0+)

### Installation

#### Ubuntu/Debian
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo apt-get update
sudo apt-get install docker-compose-plugin

# Add user to docker group (avoid using sudo)
sudo usermod -aG docker $USER
newgrp docker

# Verify installation
docker --version
docker compose version
```

#### macOS
```bash
# Install Docker Desktop from:
# https://www.docker.com/products/docker-desktop

# Verify installation
docker --version
docker compose version
```

---

## Project Structure

```
Project25/
├── docker-compose.yml          # Main orchestration file
├── DOCKER_DEPLOYMENT.md        # This file
│
├── nautilus_AItrader/
│   ├── Dockerfile              # AItrader container definition
│   ├── .dockerignore           # Files to exclude from build
│   ├── .env                    # Environment variables (API keys)
│   ├── requirements.txt        # Python dependencies
│   ├── main_live.py            # Entry point
│   ├── strategy/               # Strategy code
│   ├── utils/                  # Utility modules
│   ├── configs/                # Configuration files
│   ├── logs/                   # Log output (volume-mounted)
│   └── data/                   # Data storage (volume-mounted)
│
└── GoldArb/
    ├── Dockerfile              # GoldArb container definition
    ├── .dockerignore           # Files to exclude from build
    ├── .env                    # Environment variables (API keys)
    ├── requirements.txt        # Python dependencies
    ├── run_live.py             # Entry point
    ├── config_live.py          # Configuration
    ├── paxg_xaut_grid_strategy.py  # Strategy implementation
    ├── logs/                   # Log output (volume-mounted)
    └── data/                   # Data storage (volume-mounted)
```

---

## Initial Setup

### 1. Clone Repository (if applicable)

```bash
cd ~/
git clone <repository-url> Project25
cd Project25
```

### 2. Create Required Directories

```bash
# Create log and data directories
mkdir -p nautilus_AItrader/logs nautilus_AItrader/data
mkdir -p GoldArb/logs GoldArb/data

# Set proper permissions
chmod 755 nautilus_AItrader/logs nautilus_AItrader/data
chmod 755 GoldArb/logs GoldArb/data
```

---

## Configuration

### 1. Configure nautilus_AItrader

Edit `nautilus_AItrader/.env`:

```bash
nano nautilus_AItrader/.env
```

**Required settings:**
```bash
# Exchange API Keys
BINANCE_API_KEY=your_binance_api_key_here
BINANCE_API_SECRET=your_binance_api_secret_here

# AI Service
DEEPSEEK_API_KEY=your_deepseek_api_key_here

# Strategy Parameters
EQUITY=10000
LEVERAGE=10
BASE_POSITION_USDT=100
TIMEFRAME=15m

# Telegram (optional)
ENABLE_TELEGRAM=false
TELEGRAM_BOT_TOKEN=
TELEGRAM_CHAT_ID=
```

### 2. Configure GoldArb

Edit `GoldArb/.env`:

```bash
nano GoldArb/.env
```

**Required settings:**
```bash
# Exchange API Keys
BYBIT_API_KEY=your_bybit_api_key_here
BYBIT_API_SECRET=your_bybit_api_secret_here
BYBIT_TESTNET=false
```

### 3. Set PostgreSQL Password (Optional)

Create `.env` in project root for docker-compose:

```bash
nano .env
```

```bash
# PostgreSQL password for docker-compose
POSTGRES_PASSWORD=your_secure_password_here
```

---

## Building and Running

### First-Time Build

```bash
# Build all Docker images
docker compose build

# Or build individually
docker compose build aitrader
docker compose build goldarb
```

### Start All Services

```bash
# Start in detached mode (background)
docker compose up -d

# Start with logs visible (foreground)
docker compose up
```

### Start Individual Services

```bash
# Start only AItrader
docker compose up -d aitrader

# Start only GoldArb
docker compose up -d goldarb

# Start only supporting services
docker compose up -d redis postgres
```

---

## Management Commands

### Service Control

```bash
# Stop all services
docker compose down

# Stop but keep volumes (data persists)
docker compose down

# Stop and remove volumes (fresh start)
docker compose down -v

# Restart all services
docker compose restart

# Restart specific service
docker compose restart aitrader
docker compose restart goldarb
```

### Service Status

```bash
# Check running services
docker compose ps

# View resource usage
docker stats

# Check specific container
docker compose ps aitrader
```

---

## Monitoring and Logs

### View Logs

```bash
# All services
docker compose logs

# Follow logs (real-time)
docker compose logs -f

# Specific service
docker compose logs -f aitrader
docker compose logs -f goldarb

# Last 100 lines
docker compose logs --tail=100 aitrader

# Since specific time
docker compose logs --since 2024-01-01T00:00:00 aitrader
```

### Access Container Shell

```bash
# Access AItrader container
docker compose exec aitrader /bin/bash

# Access GoldArb container
docker compose exec goldarb /bin/bash

# Access Redis CLI
docker compose exec redis redis-cli

# Access PostgreSQL
docker compose exec postgres psql -U nautilus
```

### Check Health

```bash
# Check container health
docker compose ps

# Inspect specific container
docker inspect nautilus-aitrader

# View health check logs
docker inspect nautilus-aitrader | grep -A 10 Health
```

---

## Troubleshooting

### Common Issues

#### 1. Container Fails to Start

```bash
# Check logs for errors
docker compose logs aitrader

# Check if ports are already in use
sudo netstat -tulpn | grep 6379
sudo netstat -tulpn | grep 5432

# Rebuild container
docker compose up -d --build aitrader
```

#### 2. API Connection Errors

```bash
# Verify .env file is correct
docker compose exec aitrader env | grep API

# Test network connectivity
docker compose exec aitrader ping binance.com
docker compose exec goldarb ping api.bybit.com
```

#### 3. Out of Memory

```bash
# Check container resource usage
docker stats

# Increase memory limits in docker-compose.yml
# Edit the 'limits' section for each service
nano docker-compose.yml
```

#### 4. Permission Errors

```bash
# Fix log directory permissions
sudo chown -R $(whoami):$(whoami) nautilus_AItrader/logs
sudo chown -R $(whoami):$(whoami) GoldArb/logs
```

### Reset Everything

```bash
# Complete reset (WARNING: destroys all data)
docker compose down -v
docker system prune -a --volumes
docker compose up -d --build
```

---

## Resource Management

### Check Disk Usage

```bash
# Docker disk usage
docker system df

# Detailed breakdown
docker system df -v
```

### Clean Up

```bash
# Remove unused containers
docker container prune

# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune

# Remove everything unused
docker system prune -a --volumes
```

### Resource Limits

Adjust in `docker-compose.yml`:

```yaml
deploy:
  resources:
    limits:
      cpus: '2.0'      # Maximum CPU cores
      memory: 1G       # Maximum memory
    reservations:
      cpus: '0.5'      # Guaranteed CPU
      memory: 512M     # Guaranteed memory
```

---

## Security Best Practices

### 1. Protect API Keys

```bash
# Never commit .env files
echo ".env" >> .gitignore

# Set restrictive permissions
chmod 600 nautilus_AItrader/.env
chmod 600 GoldArb/.env
```

### 2. Use Non-Root User

Already configured in Dockerfiles:
```dockerfile
USER trader  # Container runs as non-root
```

### 3. Network Isolation

Services communicate only within `trading_network`:
```yaml
networks:
  - trading_network  # Isolated from host
```

### 4. Secure PostgreSQL

```bash
# Change default password
nano .env
POSTGRES_PASSWORD=strong_random_password_here

# Restart to apply
docker compose down
docker compose up -d
```

### 5. Regular Updates

```bash
# Update base images
docker compose pull

# Rebuild with latest packages
docker compose build --no-cache

# Restart with new images
docker compose up -d
```

---

## Backup and Recovery

### Backup Volumes

```bash
# Backup Redis data
docker run --rm -v nautilus-redis-data:/data -v $(pwd):/backup alpine tar czf /backup/redis-backup.tar.gz -C /data .

# Backup PostgreSQL data
docker compose exec postgres pg_dump -U nautilus nautilus > backup.sql
```

### Restore Volumes

```bash
# Restore Redis data
docker run --rm -v nautilus-redis-data:/data -v $(pwd):/backup alpine tar xzf /backup/redis-backup.tar.gz -C /data

# Restore PostgreSQL data
docker compose exec -T postgres psql -U nautilus nautilus < backup.sql
```

---

## Production Deployment Checklist

- [ ] Updated all API keys in `.env` files
- [ ] Changed PostgreSQL password
- [ ] Set `TEST_MODE=false` in nautilus_AItrader/.env
- [ ] Configured proper resource limits
- [ ] Set up log rotation
- [ ] Configured monitoring/alerts
- [ ] Tested restart behavior
- [ ] Set up automated backups
- [ ] Verified network connectivity
- [ ] Reviewed security settings

---

## Quick Reference

```bash
# Start everything
docker compose up -d

# Stop everything
docker compose down

# View logs (real-time)
docker compose logs -f

# Restart a strategy
docker compose restart aitrader

# Check status
docker compose ps

# Access shell
docker compose exec aitrader bash

# Update and restart
git pull
docker compose up -d --build
```

---

## Support

For issues or questions:
1. Check logs: `docker compose logs -f`
2. Review this guide
3. Check NautilusTrader documentation: https://nautilustrader.io
4. Open an issue on GitHub

---

**Last Updated:** 2024-12-14
**Version:** 1.0.0
