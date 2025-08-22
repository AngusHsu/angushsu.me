#!/bin/bash

# Backup and restore for Angus Hsu Portfolio
# Usage: 
#   ./scripts/backup.sh create [backup_name]
#   ./scripts/backup.sh restore [backup_name]
#   ./scripts/backup.sh list

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$PROJECT_DIR/backups"

cd "$PROJECT_DIR"

ACTION="$1"
BACKUP_NAME="$2"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

case "$ACTION" in
    "create")
        if [[ -z "$BACKUP_NAME" ]]; then
            BACKUP_NAME="backup_$(date +%Y%m%d_%H%M%S)"
        fi
        
        BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"
        
        echo "📦 Creating backup: $BACKUP_NAME"
        mkdir -p "$BACKUP_PATH"
        
        # Export Docker images
        echo "🖼️  Exporting Docker images..."
        if docker images | grep -q angus-portfolio; then
            docker save -o "$BACKUP_PATH/images.tar" $(docker images --filter "reference=*angus*" --filter "reference=*portfolio*" --format "{{.Repository}}:{{.Tag}}")
        fi
        
        # Backup volumes
        echo "📂 Backing up volumes..."
        docker volume ls --filter "name=angus" --format "{{.Name}}" > "$BACKUP_PATH/volumes.list"
        
        # Backup configuration files
        echo "⚙️  Backing up configuration..."
        cp docker-compose*.yml "$BACKUP_PATH/" 2>/dev/null || true
        cp Dockerfile "$BACKUP_PATH/" 2>/dev/null || true
        cp nginx.conf "$BACKUP_PATH/" 2>/dev/null || true
        cp .dockerignore "$BACKUP_PATH/" 2>/dev/null || true
        
        # Create metadata
        cat > "$BACKUP_PATH/metadata.txt" << EOF
Backup Name: $BACKUP_NAME
Created: $(date)
Docker Version: $(docker --version)
Compose Version: $(docker-compose --version)
Git Commit: $(git rev-parse HEAD 2>/dev/null || echo "N/A")
EOF
        
        echo "✅ Backup created successfully: $BACKUP_PATH"
        ;;
        
    "restore")
        if [[ -z "$BACKUP_NAME" ]]; then
            echo "❌ Please specify a backup name to restore"
            echo "📋 Available backups:"
            ls -1 "$BACKUP_DIR" 2>/dev/null || echo "No backups found"
            exit 1
        fi
        
        BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"
        
        if [[ ! -d "$BACKUP_PATH" ]]; then
            echo "❌ Backup not found: $BACKUP_NAME"
            exit 1
        fi
        
        echo "🔄 Restoring backup: $BACKUP_NAME"
        
        # Stop current containers
        echo "🛑 Stopping current containers..."
        ./scripts/stop.sh 2>/dev/null || true
        
        # Load Docker images
        if [[ -f "$BACKUP_PATH/images.tar" ]]; then
            echo "🖼️  Loading Docker images..."
            docker load -i "$BACKUP_PATH/images.tar"
        fi
        
        # Restore configuration files
        echo "⚙️  Restoring configuration..."
        cp "$BACKUP_PATH"/docker-compose*.yml . 2>/dev/null || true
        cp "$BACKUP_PATH/Dockerfile" . 2>/dev/null || true
        cp "$BACKUP_PATH/nginx.conf" . 2>/dev/null || true
        cp "$BACKUP_PATH/.dockerignore" . 2>/dev/null || true
        
        echo "✅ Backup restored successfully!"
        echo "🚀 You can now start the application with ./scripts/start.sh"
        ;;
        
    "list")
        echo "📋 Available backups:"
        if [[ -d "$BACKUP_DIR" ]]; then
            for backup in "$BACKUP_DIR"/*; do
                if [[ -d "$backup" ]]; then
                    backup_name=$(basename "$backup")
                    if [[ -f "$backup/metadata.txt" ]]; then
                        created=$(grep "Created:" "$backup/metadata.txt" | cut -d: -f2- | xargs)
                        echo "  📦 $backup_name (Created: $created)"
                    else
                        echo "  📦 $backup_name"
                    fi
                fi
            done
        else
            echo "  No backups found"
        fi
        ;;
        
    *)
        echo "❌ Invalid action. Usage:"
        echo "  ./scripts/backup.sh create [backup_name]"
        echo "  ./scripts/backup.sh restore [backup_name]"
        echo "  ./scripts/backup.sh list"
        exit 1
        ;;
esac