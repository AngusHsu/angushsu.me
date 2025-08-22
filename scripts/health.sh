#!/bin/bash

# Health check for Angus Hsu Portfolio
# Usage: ./scripts/health.sh [--verbose]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

VERBOSE=""
if [[ "$1" == "--verbose" || "$1" == "-v" ]]; then
    VERBOSE="true"
fi

echo "🔍 Performing health check for Angus Hsu Portfolio..."

# Check if containers are running
echo "📦 Checking container status..."
PORTFOLIO_RUNNING=$(docker ps --filter "name=angus-portfolio" --format "{{.Names}}" | head -1)
NGINX_RUNNING=$(docker ps --filter "name=angus-nginx" --format "{{.Names}}" | head -1)

if [[ -n "$PORTFOLIO_RUNNING" ]]; then
    echo "✅ Portfolio container is running: $PORTFOLIO_RUNNING"
else
    echo "❌ Portfolio container is not running"
    exit 1
fi

if [[ -n "$NGINX_RUNNING" ]]; then
    echo "✅ Nginx container is running: $NGINX_RUNNING"
else
    echo "ℹ️  Nginx container not found (simple mode)"
fi

# Check application response
echo "🌐 Checking application response..."

# Test direct application (port 3000)
if curl -f -s http://localhost:3000/ > /dev/null; then
    echo "✅ Application responds on port 3000"
    if [[ "$VERBOSE" == "true" ]]; then
        echo "📄 Response preview:"
        curl -s http://localhost:3000/ | head -5
        echo "..."
    fi
else
    echo "❌ Application not responding on port 3000"
    exit 1
fi

# Test nginx proxy (port 80) if available
if [[ -n "$NGINX_RUNNING" ]]; then
    if curl -f -s http://localhost:80/ > /dev/null; then
        echo "✅ Nginx proxy responds on port 80"
    else
        echo "⚠️  Nginx proxy not responding on port 80"
    fi
fi

# Check resource usage
echo "📊 Resource usage:"
if [[ -n "$PORTFOLIO_RUNNING" ]]; then
    STATS=$(docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" | grep "$PORTFOLIO_RUNNING" || echo "Stats unavailable")
    echo "  Portfolio: $STATS"
fi

if [[ -n "$NGINX_RUNNING" ]]; then
    STATS=$(docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" | grep "$NGINX_RUNNING" || echo "Stats unavailable")
    echo "  Nginx: $STATS"
fi

# Check disk usage
echo "💾 Disk usage of Docker images:"
docker images | grep -E "(angus|portfolio)" | awk '{print $1":"$2"\t"$7}' || echo "No images found"

echo ""
echo "✅ Health check completed successfully!"
echo "🌐 Your portfolio is accessible at: http://localhost:3000"
if [[ -n "$NGINX_RUNNING" ]]; then
    echo "🌐 Nginx proxy available at: http://localhost:80"
fi