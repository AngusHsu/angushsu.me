#!/bin/bash

# Start Docker containers for Angus Hsu Portfolio
# Usage: ./scripts/start.sh [simple|production]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

# Default to simple mode
MODE=${1:-simple}
COMPOSE_FILE="docker-compose.simple.yml"

if [[ "$MODE" == "production" || "$MODE" == "prod" ]]; then
    COMPOSE_FILE="docker-compose.yml"
    echo "🚀 Starting in PRODUCTION mode with Nginx reverse proxy..."
else
    echo "🚀 Starting in SIMPLE mode (direct access)..."
fi

# Check if image exists
if ! docker images | grep -q angus-portfolio && ! docker images | grep -q angushsu.me; then
    echo "⚠️  Image not found. Building first..."
    ./scripts/build.sh
fi

# Start containers
echo "📦 Starting containers using $COMPOSE_FILE..."
docker-compose -f "$COMPOSE_FILE" up -d

echo "⏳ Waiting for containers to be ready..."
sleep 5

# Show status
echo "📊 Container status:"
docker-compose -f "$COMPOSE_FILE" ps

# Health check
echo "🔍 Performing health check..."
if curl -f -s http://localhost:3000/ > /dev/null; then
    echo "✅ Application is running successfully!"
    echo "🌐 Access your portfolio at: http://localhost:3000"
else
    echo "⚠️  Health check failed. Check logs with: ./scripts/logs.sh"
fi

echo ""
echo "📝 Useful commands:"
echo "  - View logs: ./scripts/logs.sh"
echo "  - Stop containers: ./scripts/stop.sh"
echo "  - Check health: ./scripts/health.sh"