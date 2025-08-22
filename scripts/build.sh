#!/bin/bash

# Build Docker image for Angus Hsu Portfolio
# Usage: ./scripts/build.sh [--no-cache]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "🏗️  Building Angus Hsu Portfolio Docker image..."

# Parse arguments
NO_CACHE=""
if [[ "$1" == "--no-cache" ]]; then
    NO_CACHE="--no-cache"
    echo "🔄 Building with --no-cache flag"
fi

# Build the image
if [ -f "docker-compose.simple.yml" ]; then
    echo "📦 Building using docker-compose..."
    docker-compose -f docker-compose.simple.yml build $NO_CACHE
else
    echo "📦 Building using Dockerfile..."
    docker build $NO_CACHE -t angus-portfolio .
fi

echo "✅ Build completed successfully!"
echo "📊 Image info:"
docker images | grep angus-portfolio || docker images | grep angushsu.me

echo ""
echo "🚀 Next steps:"
echo "  - Start container: ./scripts/start.sh"
echo "  - Start development: ./scripts/dev.sh"
echo "  - Deploy production: ./scripts/prod.sh"