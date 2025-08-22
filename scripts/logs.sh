#!/bin/bash

# View logs for Angus Hsu Portfolio containers
# Usage: ./scripts/logs.sh [service_name] [--follow] [--tail=50]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

# Parse arguments
SERVICE=""
FOLLOW=""
TAIL="--tail=50"

for arg in "$@"; do
    case $arg in
        portfolio|nginx)
            SERVICE="$arg"
            ;;
        --follow|-f)
            FOLLOW="-f"
            ;;
        --tail=*)
            TAIL="$arg"
            ;;
    esac
done

# Determine which compose file is in use
if docker-compose -f docker-compose.yml ps 2>/dev/null | grep -q "Up"; then
    COMPOSE_FILE="docker-compose.yml"
    echo "📋 Viewing logs for PRODUCTION setup..."
else
    COMPOSE_FILE="docker-compose.simple.yml"
    echo "📋 Viewing logs for SIMPLE setup..."
fi

# Build the command
LOG_CMD="docker-compose -f $COMPOSE_FILE logs $TAIL $FOLLOW"

if [[ -n "$SERVICE" ]]; then
    LOG_CMD="$LOG_CMD $SERVICE"
    echo "🔍 Showing logs for service: $SERVICE"
else
    echo "🔍 Showing logs for all services"
fi

if [[ -n "$FOLLOW" ]]; then
    echo "👀 Following logs (Press Ctrl+C to stop)..."
else
    echo "📄 Showing recent logs..."
fi

echo "----------------------------------------"

# Execute the command
eval $LOG_CMD

echo ""
echo "💡 Tip: Use the following options:"
echo "  - Follow logs: ./scripts/logs.sh --follow"
echo "  - Specific service: ./scripts/logs.sh portfolio"
echo "  - More lines: ./scripts/logs.sh --tail=100"