# Docker Quick Reference Card

Fast command reference for managing your trading strategies.

---

## 🚀 Getting Started

```bash
# First-time setup
./docker-start.sh

# Or manual start
docker compose up -d
```

---

## 📊 Service Management

### Start/Stop

```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# Restart all services
docker compose restart

# Start specific service
docker compose up -d aitrader
docker compose up -d goldarb

# Stop specific service
docker compose stop aitrader
docker compose stop goldarb

# Restart specific service
docker compose restart aitrader
docker compose restart goldarb
```

---

## 📝 Logs & Monitoring

### View Logs

```bash
# All services (real-time)
docker compose logs -f

# AItrader logs
docker compose logs -f aitrader

# GoldArb logs
docker compose logs -f goldarb

# Last 100 lines
docker compose logs --tail=100 aitrader

# Since 1 hour ago
docker compose logs --since 1h aitrader
```

### Check Status

```bash
# Service status
docker compose ps

# Resource usage
docker stats

# Container details
docker inspect nautilus-aitrader
```

---

## 🔧 Maintenance

### Update Code

```bash
# Pull latest code
git pull

# Rebuild and restart
docker compose up -d --build

# Rebuild specific service
docker compose up -d --build aitrader
```

### Access Container

```bash
# AItrader shell
docker compose exec aitrader /bin/bash

# GoldArb shell
docker compose exec goldarb /bin/bash

# Redis CLI
docker compose exec redis redis-cli

# PostgreSQL
docker compose exec postgres psql -U nautilus
```

---

## 🧹 Cleanup

```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune -a

# Check disk usage
docker system df

# Full cleanup (careful!)
docker system prune -a --volumes
```

---

## 🔍 Troubleshooting

### Check Logs for Errors

```bash
# AItrader errors
docker compose logs aitrader | grep -i error

# GoldArb errors
docker compose logs goldarb | grep -i error
```

### Restart from Scratch

```bash
# Complete reset (destroys data!)
docker compose down -v
docker compose up -d --build
```

### Test Network

```bash
# Ping exchange from container
docker compose exec aitrader ping api.binance.com
docker compose exec goldarb ping api.bybit.com
```

---

## 📊 Resource Limits

Edit `docker-compose.yml`:

```yaml
deploy:
  resources:
    limits:
      cpus: '2.0'
      memory: 1G
```

Then restart:
```bash
docker compose down
docker compose up -d
```

---

## 🔐 Security

### Update API Keys

1. Edit `.env` file:
   ```bash
   nano nautilus_AItrader/.env
   nano GoldArb/.env
   ```

2. Restart service:
   ```bash
   docker compose restart aitrader
   docker compose restart goldarb
   ```

---

## 💾 Backup

### Backup Database

```bash
# PostgreSQL backup
docker compose exec postgres pg_dump -U nautilus nautilus > backup.sql

# Restore
docker compose exec -T postgres psql -U nautilus nautilus < backup.sql
```

### Backup Logs

```bash
# Tar logs
tar czf logs-backup-$(date +%Y%m%d).tar.gz \
  nautilus_AItrader/logs \
  GoldArb/logs
```

---

## 🎯 Common Tasks

### Update Strategy Parameters

1. Edit config:
   ```bash
   nano nautilus_AItrader/.env
   ```

2. Restart:
   ```bash
   docker compose restart aitrader
   ```

### Check Performance

```bash
# Real-time stats
docker stats

# Container processes
docker compose top aitrader
docker compose top goldarb
```

### View Environment Variables

```bash
# AItrader env
docker compose exec aitrader env

# Check specific variable
docker compose exec aitrader env | grep BINANCE_API_KEY
```

---

## 🆘 Emergency Stop

```bash
# Immediate stop all containers
docker compose kill

# Then clean shutdown
docker compose down
```

---

## 📱 Status Check Script

Create `check-status.sh`:

```bash
#!/bin/bash
echo "=== Docker Services ==="
docker compose ps

echo -e "\n=== Resource Usage ==="
docker stats --no-stream

echo -e "\n=== Recent Logs (AItrader) ==="
docker compose logs --tail=10 aitrader

echo -e "\n=== Recent Logs (GoldArb) ==="
docker compose logs --tail=10 goldarb
```

Make executable:
```bash
chmod +x check-status.sh
./check-status.sh
```

---

## 📚 Full Documentation

For complete guide, see: **DOCKER_DEPLOYMENT.md**
