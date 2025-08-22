# 🚀 Portfolio Deployment Scripts

This directory contains comprehensive Docker management scripts for the Angus Hsu Portfolio website.

## 🎯 Quick Start

```bash
# Main script with menu
./scripts/portfolio.sh

# Development
./scripts/portfolio.sh dev

# Production deployment
./scripts/portfolio.sh prod

# View status
./scripts/portfolio.sh status
```

## 📋 Available Scripts

### 🏗️ Core Scripts

| Script | Description | Usage |
|--------|-------------|-------|
| `portfolio.sh` | Main script with menu interface | `./scripts/portfolio.sh [command]` |
| `build.sh` | Build Docker image | `./scripts/build.sh [--no-cache]` |
| `start.sh` | Start containers | `./scripts/start.sh [simple\|production]` |
| `stop.sh` | Stop containers | `./scripts/stop.sh [simple\|production] [--remove-volumes]` |

### 🚀 Environment Scripts

| Script | Description | Usage |
|--------|-------------|-------|
| `dev.sh` | Development setup | `./scripts/dev.sh [--rebuild]` |
| `prod.sh` | Production deployment | `./scripts/prod.sh [--rebuild] [--pull]` |

### 📊 Monitoring Scripts

| Script | Description | Usage |
|--------|-------------|-------|
| `logs.sh` | View container logs | `./scripts/logs.sh [service] [--follow] [--tail=N]` |
| `health.sh` | Health check | `./scripts/health.sh [--verbose]` |
| `monitor.sh` | Live monitoring | `./scripts/monitor.sh [--interval=5] [--duration=60]` |

### 🧹 Maintenance Scripts

| Script | Description | Usage |
|--------|-------------|-------|
| `cleanup.sh` | Clean Docker resources | `./scripts/cleanup.sh [--force] [--all]` |
| `backup.sh` | Backup/restore system | `./scripts/backup.sh [create\|restore\|list] [name]` |

## 🎮 Common Workflows

### Development Workflow
```bash
# Start development environment
./scripts/dev.sh

# View logs while developing
./scripts/logs.sh --follow

# Rebuild after changes
./scripts/dev.sh --rebuild

# Stop when done
./scripts/stop.sh
```

### Production Deployment
```bash
# Deploy to production
./scripts/prod.sh --pull --rebuild

# Monitor the deployment
./scripts/monitor.sh

# Check health
./scripts/health.sh --verbose

# View production logs
./scripts/logs.sh nginx --follow
```

### Backup & Restore
```bash
# Create backup
./scripts/backup.sh create production-backup

# List backups
./scripts/backup.sh list

# Restore backup
./scripts/backup.sh restore production-backup
```

### Troubleshooting
```bash
# Check current status
./scripts/portfolio.sh status

# View detailed health info
./scripts/health.sh --verbose

# Check recent logs
./scripts/logs.sh --tail=50

# Complete cleanup and restart
./scripts/cleanup.sh --force
./scripts/build.sh --no-cache
./scripts/start.sh
```

## 🔧 Configuration

### Environment Modes

**Simple Mode** (Development):
- Single container setup
- Direct access on port 3000
- Faster startup time
- Good for development and testing

**Production Mode**:
- Multi-container setup with Nginx reverse proxy
- Access through port 80 (Nginx) and port 3000 (direct)
- Production-optimized configuration
- Security headers and caching

### Customization

Edit these files to customize your setup:
- `docker-compose.yml` - Production configuration
- `docker-compose.simple.yml` - Simple configuration
- `nginx.conf` - Nginx reverse proxy settings
- `Dockerfile` - Container build configuration

## 📊 Monitoring

### Health Checks
All scripts include health checking functionality:
- HTTP endpoint testing
- Container status verification
- Resource usage monitoring
- Response time measurement

### Logging
- Application logs: Container stdout/stderr
- Nginx logs: Access and error logs
- System logs: Docker events and metrics

## 🛡️ Security Features

- Non-root container execution
- Security headers (XSS, CSRF protection)
- Rate limiting (in production mode)
- SSL/TLS ready (certificate configuration needed)

## 🚨 Troubleshooting

### Common Issues

**Port conflicts:**
```bash
# Check what's using the ports
sudo lsof -i :3000
sudo lsof -i :80

# Stop conflicting services or change ports
```

**Permission errors:**
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Fix Docker permissions (if needed)
sudo usermod -aG docker $USER
```

**Container won't start:**
```bash
# Check logs for errors
./scripts/logs.sh

# Rebuild image
./scripts/build.sh --no-cache

# Clean up and retry
./scripts/cleanup.sh --force
./scripts/start.sh
```

**Out of disk space:**
```bash
# Clean up Docker resources
./scripts/cleanup.sh --all

# Remove unused Docker data
docker system prune -a --volumes
```

## 📞 Support

For issues with these scripts:
1. Check the logs: `./scripts/logs.sh`
2. Verify health: `./scripts/health.sh --verbose`
3. Try cleanup and rebuild: `./scripts/cleanup.sh --force && ./scripts/build.sh --no-cache`

---

*Generated for Angus Hsu Portfolio v1.0.0*