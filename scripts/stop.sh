#!/bin/bash

# Stop Docker containers for Angus Hsu Portfolio
# Usage: ./scripts/stop.sh [simple|production] [--remove-volumes]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

# Parse arguments
MODE=""
REMOVE_VOLUMES=""

for arg in "$@"; do
    case $arg in
        simple|production|prod)
            MODE="$arg"
            ;;
        --remove-volumes)
            REMOVE_VOLUMES="-v"
            ;;
    esac
done

# Determine compose file
if [[ "$MODE" == "production" || "$MODE" == "prod" ]]; then
    COMPOSE_FILE="docker-compose.yml"
    echo "🛑 Stopping PRODUCTION containers..."
elif [[ "$MODE" == "simple" ]]; then
    COMPOSE_FILE="docker-compose.simple.yml"
    echo "🛑 Stopping SIMPLE containers..."
else
    # Try to detect which containers are running
    if docker-compose -f docker-compose.yml ps | grep -q "Up"; then
        COMPOSE_FILE="docker-compose.yml"
        echo "🛑 Stopping PRODUCTION containers..."
    else
        COMPOSE_FILE="docker-compose.simple.yml"
        echo "🛑 Stopping SIMPLE containers..."
    fi
fi

# Stop containers
echo "📦 Stopping containers using $COMPOSE_FILE..."
docker-compose -f "$COMPOSE_FILE" down $REMOVE_VOLUMES

if [[ -n "$REMOVE_VOLUMES" ]]; then
    echo "🗑️  Volumes removed"
fi

echo "✅ Containers stopped successfully!"

# Show remaining containers (if any)
RUNNING_CONTAINERS=$(docker ps --filter "name=angus" --format "table {{.Names}}\t{{.Status}}" | tail -n +2)
if [[ -n "$RUNNING_CONTAINERS" ]]; then
    echo "⚠️  Some related containers are still running:"
    echo "$RUNNING_CONTAINERS"
else
    echo "🔍 No related containers are currently running"
fi

echo ""
echo "🚀 To start again:"
echo "  - Simple mode: ./scripts/start.sh"
echo "  - Production mode: ./scripts/start.sh production"