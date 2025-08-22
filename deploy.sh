#!/bin/bash

# Deployment script for Angus Hsu Portfolio
# Usage: ./deploy.sh [environment]

set -e

ENVIRONMENT=${1:-production}
COMPOSE_FILE="docker-compose.yml"

if [ "$ENVIRONMENT" = "simple" ]; then
    COMPOSE_FILE="docker-compose.simple.yml"
fi

echo "🚀 Deploying Angus Hsu Portfolio in $ENVIRONMENT mode..."

# Pull latest changes (if this is run on server)
if [ -d ".git" ]; then
    echo "📦 Pulling latest changes..."
    git pull origin main
fi

# Build and deploy
echo "🏗️  Building Docker image..."
docker-compose -f $COMPOSE_FILE build --no-cache

echo "🔄 Stopping existing containers..."
docker-compose -f $COMPOSE_FILE down

echo "🚀 Starting new containers..."
docker-compose -f $COMPOSE_FILE up -d

echo "🧹 Cleaning up unused images..."
docker image prune -f

echo "✅ Deployment complete!"
echo "📊 Container status:"
docker-compose -f $COMPOSE_FILE ps

echo "📝 To view logs: docker-compose -f $COMPOSE_FILE logs -f"
echo "🔍 To check health: curl -f http://localhost:3000/"