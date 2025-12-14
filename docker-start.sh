#!/bin/bash
# ============================================================================
# Quick Start Script for Docker Deployment
# ============================================================================
# This script helps you quickly deploy both trading strategies with Docker
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
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

check_command() {
    if ! command -v $1 &> /dev/null; then
        print_error "$1 is not installed"
        return 1
    else
        print_success "$1 is installed"
        return 0
    fi
}

# Main script
print_header "Docker Deployment - Quick Start"

# Step 1: Check prerequisites
print_header "Step 1: Checking Prerequisites"

if ! check_command docker; then
    print_error "Docker is required. Please install Docker first."
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! docker compose version &> /dev/null; then
    print_error "Docker Compose is required"
    exit 1
else
    print_success "Docker Compose is installed"
fi

# Step 2: Check .env files
print_header "Step 2: Checking Configuration Files"

if [ ! -f "nautilus_AItrader/.env" ]; then
    print_warning "nautilus_AItrader/.env not found"
    echo "Creating from template..."
    cp nautilus_AItrader/.env.template nautilus_AItrader/.env
    print_warning "Please edit nautilus_AItrader/.env and add your API keys"
    exit 1
else
    print_success "nautilus_AItrader/.env exists"
fi

if [ ! -f "GoldArb/.env" ]; then
    print_warning "GoldArb/.env not found"
    echo "Creating from template..."
    cp GoldArb/.env.example GoldArb/.env
    print_warning "Please edit GoldArb/.env and add your API keys"
    exit 1
else
    print_success "GoldArb/.env exists"
fi

# Step 3: Create directories
print_header "Step 3: Creating Required Directories"

mkdir -p nautilus_AItrader/logs nautilus_AItrader/data
mkdir -p GoldArb/logs GoldArb/data

print_success "Directories created"

# Step 4: Build Docker images
print_header "Step 4: Building Docker Images"

echo "This may take a few minutes..."
if docker compose build; then
    print_success "Docker images built successfully"
else
    print_error "Failed to build Docker images"
    exit 1
fi

# Step 5: Safety check
print_header "Step 5: Safety Confirmation"

echo -e "${YELLOW}You are about to start LIVE trading strategies.${NC}"
echo ""
echo "Strategies to be started:"
echo "  1. nautilus_AItrader (Binance Futures - BTCUSDT)"
echo "  2. GoldArb (Bybit - PAXG/XAUT)"
echo ""
echo -e "${RED}WARNING: Real money will be at risk!${NC}"
echo ""

read -p "Do you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    print_warning "Deployment cancelled by user"
    exit 0
fi

# Step 6: Start services
print_header "Step 6: Starting Services"

if docker compose up -d; then
    print_success "All services started successfully"
else
    print_error "Failed to start services"
    exit 1
fi

# Step 7: Show status
print_header "Step 7: Service Status"

sleep 3  # Wait for services to initialize

docker compose ps

# Step 8: Final instructions
print_header "Deployment Complete!"

echo "Your trading strategies are now running in Docker containers."
echo ""
echo "Useful commands:"
echo ""
echo "  View logs (all):           ${GREEN}docker compose logs -f${NC}"
echo "  View AItrader logs:        ${GREEN}docker compose logs -f aitrader${NC}"
echo "  View GoldArb logs:         ${GREEN}docker compose logs -f goldarb${NC}"
echo "  Check status:              ${GREEN}docker compose ps${NC}"
echo "  Stop all:                  ${GREEN}docker compose down${NC}"
echo "  Restart AItrader:          ${GREEN}docker compose restart aitrader${NC}"
echo "  Restart GoldArb:           ${GREEN}docker compose restart goldarb${NC}"
echo ""
echo "For detailed documentation, see: DOCKER_DEPLOYMENT.md"
echo ""

print_success "Setup complete! Monitor your strategies using the commands above."
