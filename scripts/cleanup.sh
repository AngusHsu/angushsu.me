#!/bin/bash

# Cleanup Docker resources for Angus Hsu Portfolio
# Usage: ./scripts/cleanup.sh [--force] [--all]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

FORCE=""
ALL=""

for arg in "$@"; do
    case $arg in
        --force|-f)
            FORCE="true"
            ;;
        --all|-a)
            ALL="true"
            ;;
    esac
done

echo "🧹 Starting cleanup for Angus Hsu Portfolio..."

if [[ "$FORCE" != "true" ]]; then
    echo "⚠️  This will remove Docker images, containers, and volumes."
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Cleanup cancelled"
        exit 0
    fi
fi

# Stop containers first
echo "🛑 Stopping all containers..."
./scripts/stop.sh --remove-volumes 2>/dev/null || true

# Remove containers
echo "🗑️  Removing containers..."
docker ps -a --filter "name=angus" --format "{{.Names}}" | xargs -r docker rm -f || true

# Remove images
echo "🖼️  Removing images..."
docker images --filter "reference=*angus*" --format "{{.Repository}}:{{.Tag}}" | xargs -r docker rmi -f || true
docker images --filter "reference=*portfolio*" --format "{{.Repository}}:{{.Tag}}" | xargs -r docker rmi -f || true

# Remove volumes
echo "📦 Removing volumes..."
docker volume ls --filter "name=angus" --format "{{.Name}}" | xargs -r docker volume rm || true

# Remove networks
echo "🌐 Removing networks..."
docker network ls --filter "name=angus" --format "{{.Name}}" | xargs -r docker network rm || true

if [[ "$ALL" == "true" ]]; then
    echo "🧹 Performing system-wide cleanup..."
    
    # Remove dangling images
    docker image prune -f
    
    # Remove unused containers
    docker container prune -f
    
    # Remove unused volumes
    docker volume prune -f
    
    # Remove unused networks
    docker network prune -f
    
    echo "🗑️  System-wide cleanup completed"
fi

echo "✅ Cleanup completed successfully!"

# Show remaining Docker resources
echo "📊 Remaining Docker resources:"
echo "Containers:"
docker ps -a --format "table {{.Names}}\t{{.Status}}" | head -5

echo "Images:"
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | head -5

echo "Volumes:"
docker volume ls --format "table {{.Name}}\t{{.Driver}}" | head -5

echo ""
echo "🚀 To rebuild and start:"
echo "  ./scripts/build.sh"
echo "  ./scripts/start.sh"