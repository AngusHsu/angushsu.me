#!/bin/bash

# Production deployment for Angus Hsu Portfolio
# Usage: ./scripts/prod.sh [--rebuild] [--pull]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

REBUILD=""
PULL=""

for arg in "$@"; do
    case $arg in
        --rebuild)
            REBUILD="true"
            ;;
        --pull)
            PULL="true"
            ;;
    esac
done

echo "🚀 Deploying Angus Hsu Portfolio to PRODUCTION..."

# Pull latest changes if requested
if [[ "$PULL" == "true" && -d ".git" ]]; then
    echo "📦 Pulling latest changes from repository..."
    git pull origin main
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
./scripts/stop.sh production 2>/dev/null || true

# Rebuild if requested or if image doesn't exist
if [[ "$REBUILD" == "true" ]] || ! docker images | grep -q angus-portfolio; then
    echo "🏗️  Building production image..."
    ./scripts/build.sh --no-cache
fi

# Start production environment
echo "🚀 Starting production environment..."
./scripts/start.sh production

echo "⏳ Waiting for services to stabilize..."
sleep 10

# Perform comprehensive health check
echo "🔍 Performing production health check..."
./scripts/health.sh --verbose

# Cleanup old images
echo "🧹 Cleaning up old images..."
docker image prune -f

echo ""
echo "✅ Production deployment completed successfully!"
echo ""
echo "🌐 Production URLs:"
echo "  - Main site: http://localhost:80"
echo "  - Direct app: http://localhost:3000"
echo ""
echo "📊 Production monitoring:"
echo "  - View logs: ./scripts/logs.sh --follow"
echo "  - Health check: ./scripts/health.sh"
echo "  - Container status: docker-compose -f docker-compose.yml ps"
echo ""
echo "🔧 Production management:"
echo "  - Update deployment: ./scripts/prod.sh --pull --rebuild"
echo "  - Stop services: ./scripts/stop.sh production"
echo "  - View Nginx logs: ./scripts/logs.sh nginx"
echo ""
echo "⚠️  Production Notes:"
echo "  - Ensure SSL certificates are configured for HTTPS"
echo "  - Monitor logs regularly for any issues"
echo "  - Set up automated backups if needed"
echo "  - Configure firewall to allow only necessary ports"