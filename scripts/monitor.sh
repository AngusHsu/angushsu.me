#!/bin/bash

# Monitor Angus Hsu Portfolio containers
# Usage: ./scripts/monitor.sh [--interval=5] [--duration=60]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

INTERVAL=5
DURATION=60

for arg in "$@"; do
    case $arg in
        --interval=*)
            INTERVAL="${arg#*=}"
            ;;
        --duration=*)
            DURATION="${arg#*=}"
            ;;
    esac
done

echo "📊 Starting monitoring for Angus Hsu Portfolio..."
echo "⏱️  Interval: ${INTERVAL}s, Duration: ${DURATION}s"
echo "📋 Press Ctrl+C to stop monitoring"
echo ""

START_TIME=$(date +%s)

while true; do
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))
    
    if [[ $ELAPSED -gt $DURATION ]]; then
        echo "⏰ Monitoring duration reached ($DURATION seconds)"
        break
    fi
    
    clear
    echo "🖥️  Angus Hsu Portfolio - Live Monitor"
    echo "⏱️  Elapsed: ${ELAPSED}s / ${DURATION}s | Interval: ${INTERVAL}s"
    echo "📅 $(date)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Container Status
    echo "📦 CONTAINER STATUS:"
    PORTFOLIO_STATUS=$(docker ps --filter "name=angus-portfolio" --format "{{.Status}}" | head -1)
    NGINX_STATUS=$(docker ps --filter "name=angus-nginx" --format "{{.Status}}" | head -1)
    
    if [[ -n "$PORTFOLIO_STATUS" ]]; then
        echo "  ✅ Portfolio: $PORTFOLIO_STATUS"
    else
        echo "  ❌ Portfolio: Not running"
    fi
    
    if [[ -n "$NGINX_STATUS" ]]; then
        echo "  ✅ Nginx: $NGINX_STATUS"
    else
        echo "  ℹ️  Nginx: Not running (simple mode)"
    fi
    
    echo ""
    
    # Resource Usage
    echo "💾 RESOURCE USAGE:"
    if docker ps --filter "name=angus" --format "{{.Names}}" | grep -q .; then
        docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}" $(docker ps --filter "name=angus" --format "{{.Names}}")
    else
        echo "  No containers running"
    fi
    
    echo ""
    
    # Health Check
    echo "🔍 HEALTH CHECK:"
    if curl -f -s http://localhost:3000/ > /dev/null 2>&1; then
        RESPONSE_TIME=$(curl -o /dev/null -s -w "%{time_total}" http://localhost:3000/)
        echo "  ✅ Port 3000: Responding (${RESPONSE_TIME}s)"
    else
        echo "  ❌ Port 3000: Not responding"
    fi
    
    if [[ -n "$NGINX_STATUS" ]]; then
        if curl -f -s http://localhost:80/ > /dev/null 2>&1; then
            RESPONSE_TIME=$(curl -o /dev/null -s -w "%{time_total}" http://localhost:80/)
            echo "  ✅ Port 80: Responding (${RESPONSE_TIME}s)"
        else
            echo "  ❌ Port 80: Not responding"
        fi
    fi
    
    echo ""
    
    # Recent Logs (last 5 lines)
    echo "📋 RECENT LOGS:"
    if docker ps --filter "name=angus-portfolio" --format "{{.Names}}" | grep -q .; then
        docker logs --tail=3 angus-portfolio 2>/dev/null | sed 's/^/  /' || echo "  No logs available"
    else
        echo "  No portfolio container running"
    fi
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "💡 Commands: ./scripts/logs.sh | ./scripts/health.sh | ./scripts/stop.sh"
    
    sleep $INTERVAL
done

echo ""
echo "✅ Monitoring completed!"