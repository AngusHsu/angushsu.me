#!/bin/bash

# Development setup for Angus Hsu Portfolio
# Usage: ./scripts/dev.sh [--rebuild]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

REBUILD=""
if [[ "$1" == "--rebuild" ]]; then
    REBUILD="true"
fi

echo "🚀 Setting up development environment for Angus Hsu Portfolio..."

# Stop any running containers
echo "🛑 Stopping any running containers..."
./scripts/stop.sh 2>/dev/null || true

if [[ "$REBUILD" == "true" ]]; then
    echo "🔄 Rebuilding image..."
    ./scripts/build.sh --no-cache
fi

# Start in simple mode for development
echo "📦 Starting development containers..."
./scripts/start.sh simple

echo "🔍 Waiting for application to be ready..."
sleep 5

# Perform health check
./scripts/health.sh

echo ""
echo "✅ Development environment is ready!"
echo "🌐 Portfolio URL: http://localhost:3000"
echo ""
echo "💻 Development commands:"
echo "  - View logs: ./scripts/logs.sh --follow"
echo "  - Restart: ./scripts/dev.sh --rebuild"
echo "  - Stop: ./scripts/stop.sh"
echo "  - Health check: ./scripts/health.sh"
echo ""
echo "📝 File watching:"
echo "  - Changes require rebuild and restart"
echo "  - For live reload, use: npm run dev (without Docker)"
echo ""
echo "🐛 Debugging:"
echo "  - Container shell: docker exec -it angus-portfolio sh"
echo "  - Application logs: docker logs angus-portfolio"