#!/bin/bash

# Main script for Angus Hsu Portfolio management
# Usage: ./scripts/portfolio.sh [command] [options]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

show_banner() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}        ${CYAN}🚀 Angus Hsu Portfolio Manager${NC}         ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}          ${YELLOW}Docker Deployment Scripts${NC}            ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════╝${NC}"
    echo ""
}

show_help() {
    show_banner
    echo -e "${YELLOW}📋 Available Commands:${NC}"
    echo ""
    echo -e "  ${GREEN}🏗️  Building & Deployment:${NC}"
    echo -e "    ${CYAN}build${NC}         Build Docker image"
    echo -e "    ${CYAN}start${NC}         Start containers (simple mode)"
    echo -e "    ${CYAN}stop${NC}          Stop all containers"
    echo -e "    ${CYAN}restart${NC}       Restart containers"
    echo -e "    ${CYAN}dev${NC}           Start development environment"
    echo -e "    ${CYAN}prod${NC}          Deploy to production"
    echo ""
    echo -e "  ${GREEN}📊 Monitoring & Debugging:${NC}"
    echo -e "    ${CYAN}logs${NC}          View container logs"
    echo -e "    ${CYAN}health${NC}        Check application health"
    echo -e "    ${CYAN}monitor${NC}       Live monitoring dashboard"
    echo -e "    ${CYAN}status${NC}        Show current status"
    echo ""
    echo -e "  ${GREEN}🧹 Maintenance:${NC}"
    echo -e "    ${CYAN}cleanup${NC}       Clean up Docker resources"
    echo -e "    ${CYAN}backup${NC}        Create backup"
    echo -e "    ${CYAN}restore${NC}       Restore from backup"
    echo ""
    echo -e "  ${GREEN}ℹ️  Information:${NC}"
    echo -e "    ${CYAN}help${NC}          Show this help menu"
    echo -e "    ${CYAN}version${NC}       Show version information"
    echo ""
    echo -e "${YELLOW}📝 Examples:${NC}"
    echo -e "  ./scripts/portfolio.sh build --no-cache"
    echo -e "  ./scripts/portfolio.sh start production"
    echo -e "  ./scripts/portfolio.sh logs --follow"
    echo -e "  ./scripts/portfolio.sh backup create my-backup"
    echo ""
}

show_status() {
    echo -e "${YELLOW}📊 Current Status:${NC}"
    echo ""
    
    # Container status
    PORTFOLIO_RUNNING=$(docker ps --filter "name=angus-portfolio" --format "{{.Names}}" | head -1)
    NGINX_RUNNING=$(docker ps --filter "name=angus-nginx" --format "{{.Names}}" | head -1)
    
    if [[ -n "$PORTFOLIO_RUNNING" ]]; then
        echo -e "  ✅ Portfolio: ${GREEN}Running${NC}"
    else
        echo -e "  ❌ Portfolio: ${RED}Stopped${NC}"
    fi
    
    if [[ -n "$NGINX_RUNNING" ]]; then
        echo -e "  ✅ Nginx: ${GREEN}Running${NC}"
    else
        echo -e "  ℹ️  Nginx: ${YELLOW}Not running (simple mode)${NC}"
    fi
    
    echo ""
    
    # URLs
    if [[ -n "$PORTFOLIO_RUNNING" ]]; then
        echo -e "${YELLOW}🌐 Access URLs:${NC}"
        echo -e "  📱 Portfolio: ${CYAN}http://localhost:3000${NC}"
        if [[ -n "$NGINX_RUNNING" ]]; then
            echo -e "  🌐 Nginx Proxy: ${CYAN}http://localhost:80${NC}"
        fi
        echo ""
    fi
    
    # Quick actions
    echo -e "${YELLOW}🚀 Quick Actions:${NC}"
    if [[ -n "$PORTFOLIO_RUNNING" ]]; then
        echo -e "  ./scripts/portfolio.sh logs"
        echo -e "  ./scripts/portfolio.sh health"
        echo -e "  ./scripts/portfolio.sh stop"
    else
        echo -e "  ./scripts/portfolio.sh build"
        echo -e "  ./scripts/portfolio.sh start"
        echo -e "  ./scripts/portfolio.sh dev"
    fi
    echo ""
}

show_version() {
    echo -e "${YELLOW}📋 Version Information:${NC}"
    echo ""
    echo -e "  Portfolio Manager: ${GREEN}v1.0.0${NC}"
    echo -e "  Docker: ${CYAN}$(docker --version | cut -d' ' -f3 | tr -d ',')${NC}"
    echo -e "  Docker Compose: ${CYAN}$(docker-compose --version | cut -d' ' -f4 | tr -d ',')${NC}"
    echo -e "  Node.js: ${CYAN}$(node --version 2>/dev/null || echo 'Not installed')${NC}"
    if [[ -d ".git" ]]; then
        echo -e "  Git Commit: ${CYAN}$(git rev-parse --short HEAD 2>/dev/null || echo 'N/A')${NC}"
    fi
    echo ""
}

COMMAND="$1"
shift || true

case "$COMMAND" in
    "build")
        ./scripts/build.sh "$@"
        ;;
    "start")
        ./scripts/start.sh "$@"
        ;;
    "stop")
        ./scripts/stop.sh "$@"
        ;;
    "restart")
        echo -e "${YELLOW}🔄 Restarting containers...${NC}"
        ./scripts/stop.sh "$@"
        sleep 2
        ./scripts/start.sh "$@"
        ;;
    "dev")
        ./scripts/dev.sh "$@"
        ;;
    "prod")
        ./scripts/prod.sh "$@"
        ;;
    "logs")
        ./scripts/logs.sh "$@"
        ;;
    "health")
        ./scripts/health.sh "$@"
        ;;
    "monitor")
        ./scripts/monitor.sh "$@"
        ;;
    "cleanup")
        ./scripts/cleanup.sh "$@"
        ;;
    "backup")
        ./scripts/backup.sh "$@"
        ;;
    "restore")
        ./scripts/backup.sh restore "$@"
        ;;
    "status")
        show_status
        ;;
    "version")
        show_version
        ;;
    "help"|"--help"|"-h"|"")
        show_help
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $COMMAND${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac