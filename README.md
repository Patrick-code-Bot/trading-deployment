# Trading Deployment Infrastructure

Docker orchestration for NautilusTrader algorithmic trading strategies.

## 📊 Overview

This repository contains the Docker infrastructure to deploy and orchestrate multiple NautilusTrader strategies:

- **nautilus_AItrader**: AI-powered trading strategy on Binance Futures (BTCUSDT)
- **GoldArb**: Grid trading strategy on Bybit (PAXG/XAUT)

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│        Docker Compose Network           │
│                                         │
│  ┌──────────────┐  ┌──────────────┐   │
│  │  AItrader    │  │   GoldArb    │   │
│  │  (Binance)   │  │   (Bybit)    │   │
│  └──────┬───────┘  └───────┬──────┘   │
│         │                  │           │
│    ┌────┴──────────────────┴────┐     │
│    │                             │     │
│  ┌─▼────────┐        ┌──────────▼─┐  │
│  │  Redis   │        │ PostgreSQL │  │
│  │  (Cache) │        │   (Data)   │  │
│  └──────────┘        └────────────┘  │
│                                       │
└─────────────────────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- 4GB+ RAM recommended
- 5GB+ disk space

### One-Command Deploy

```bash
./docker-start.sh
```

Or manually:

```bash
# Clone this repo
git clone https://github.com/Patrick-code-Bot/trading-deployment.git
cd trading-deployment

# Clone strategy repositories
git clone https://github.com/Patrick-code-Bot/nautilus_AItrader.git
git clone https://github.com/Patrick-code-Bot/GoldArb.git

# Configure API keys
cp nautilus_AItrader/.env.template nautilus_AItrader/.env
cp GoldArb/.env.example GoldArb/.env
nano nautilus_AItrader/.env  # Add your API keys
nano GoldArb/.env            # Add your API keys

# Start services
docker compose up -d
```

## 📚 Documentation

- **[DOCKER_DEPLOYMENT.md](DOCKER_DEPLOYMENT.md)** - Complete deployment guide
- **[DOCKER_QUICKREF.md](DOCKER_QUICKREF.md)** - Quick command reference
- **[GIT_REPOSITORY_GUIDE.md](GIT_REPOSITORY_GUIDE.md)** - Repository management guide

## 🔧 Management Commands

```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Stop all services
docker compose down

# Restart a specific strategy
docker compose restart aitrader

# Check status
docker compose ps

# View resource usage
docker stats
```

## 📦 Services

### Trading Strategies

| Service | Exchange | Instrument | Status |
|---------|----------|------------|--------|
| **aitrader** | Binance Futures | BTCUSDT-PERP | ✓ Active |
| **goldarb** | Bybit Spot | PAXG/XAUT | ✓ Active |

### Infrastructure

| Service | Purpose | Port |
|---------|---------|------|
| **redis** | Cache & messaging | 6379 |
| **postgres** | Data persistence | 5432 |

## 🔐 Security

**⚠️ IMPORTANT: Never commit `.env` files containing API keys!**

Required environment variables:

### nautilus_AItrader
```bash
BINANCE_API_KEY=your_key
BINANCE_API_SECRET=your_secret
DEEPSEEK_API_KEY=your_key
```

### GoldArb
```bash
BYBIT_API_KEY=your_key
BYBIT_API_SECRET=your_secret
BYBIT_TESTNET=false
```

## 📊 Resource Limits

Default per strategy:
- **CPU**: 0.5-2.0 cores
- **Memory**: 512MB-1GB
- **Disk**: ~500MB per strategy

Adjust in `docker-compose.yml` if needed.

## 🛠️ Troubleshooting

### Container won't start
```bash
docker compose logs aitrader
docker compose logs goldarb
```

### Reset everything
```bash
docker compose down -v
docker compose up -d --build
```

### Check connectivity
```bash
docker compose exec aitrader ping api.binance.com
docker compose exec goldarb ping api.bybit.com
```

## 📖 Strategy Repositories

- [nautilus_AItrader](https://github.com/Patrick-code-Bot/nautilus_AItrader) - DeepSeek AI Strategy
- [GoldArb](https://github.com/Patrick-code-Bot/GoldArb) - Grid Trading Strategy

## 🔄 Updates

### Update strategy code
```bash
cd nautilus_AItrader
git pull origin main
cd ..
docker compose up -d --build aitrader
```

### Update Docker configuration
```bash
git pull origin main
docker compose down
docker compose up -d
```

## 🆘 Support

For issues or questions:
1. Check [DOCKER_DEPLOYMENT.md](DOCKER_DEPLOYMENT.md)
2. Review logs: `docker compose logs -f`
3. Open an issue on GitHub

## 📝 License

See individual strategy repositories for license information.

## ⚠️ Disclaimer

This software is for educational and research purposes. Trading cryptocurrencies involves substantial risk of loss. Always test thoroughly before live trading.

---

**Built with:** [NautilusTrader](https://nautilustrader.io) | **Powered by:** Docker
