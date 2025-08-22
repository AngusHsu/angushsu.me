# 🥧 Raspberry Pi Deployment Guide

Complete guide to deploy your Angus Hsu Portfolio to a Raspberry Pi server with existing nginx.

## 🎯 Quick Deployment

If your Raspberry Pi is already set up with Docker and SSH keys:

```bash
# Deploy to your Pi (replace with your Pi's address)
./scripts/deploy-pi.sh pi@raspberry.local

# Or with your custom domain
./scripts/deploy-pi.sh pi@your-server.com --domain=angushsu.me
```

## 📋 Prerequisites

### On Your Local Machine:
- Docker with buildx support
- SSH access to your Raspberry Pi
- This repository cloned locally

### On Your Raspberry Pi:
- Raspberry Pi OS (64-bit recommended)
- SSH enabled
- Existing nginx installation
- Internet connection

## 🛠️ Initial Setup

### 1. First Time Setup

Run the setup command to install Docker and prepare the environment:

```bash
./scripts/deploy-pi.sh pi@raspberry.local --setup
```

This will:
- Install Docker and Docker Compose
- Set up user permissions
- Create necessary directories
- Verify nginx installation

**Important:** After setup, log out and back in to apply Docker group permissions:
```bash
ssh pi@raspberry.local
exit
ssh pi@raspberry.local
```

### 2. Verify Setup

Check that everything is installed correctly:

```bash
ssh pi@raspberry.local
docker --version
docker-compose --version
nginx -v
```

## 🚀 Deployment Process

### Basic Deployment

```bash
./scripts/deploy-pi.sh pi@raspberry.local
```

### Advanced Deployment Options

```bash
# Full setup with SSL
./scripts/deploy-pi.sh pi@raspberry.local --setup --ssl --domain=angushsu.me

# Just deploy with custom domain
./scripts/deploy-pi.sh pi@raspberry.local --domain=your-domain.com

# Deploy with SSL (requires domain pointing to your Pi)
./scripts/deploy-pi.sh pi@raspberry.local --ssl --domain=angushsu.me
```

## 🔧 What Gets Deployed

### Docker Configuration
- **Container**: Runs on port 611 (publicly accessible)
- **Memory Limit**: 512MB (suitable for Raspberry Pi)
- **Auto-restart**: Container restarts automatically
- **Health Checks**: Built-in application health monitoring
- **Direct Access**: `http://your-pi-ip:611`

### Multi-Site Setup
- **Port 611**: Your portfolio (direct access)
- **Other Ports**: Your other websites
- **No nginx conflicts**: Each site runs on its own port
- **Static Assets**: Optimized caching for CSS, JS, images
- **Security Headers**: XSS protection, CSRF prevention
- **Rate Limiting**: Prevents abuse (10 requests/second)

### Systemd Service
- **Auto-start**: Portfolio starts automatically on boot
- **Service Management**: Use systemctl commands to control

## 🌐 Nginx Integration

The deployment works with your existing nginx by:

1. **Creating a new site config**: `/etc/nginx/sites-available/angushsu.me`
2. **Enabling the site**: Symlink to `/etc/nginx/sites-enabled/`
3. **Testing configuration**: Validates before applying
4. **Reloading nginx**: Applies new configuration

### Manual Nginx Configuration

If you prefer manual setup, the nginx config file is created at:
```
~/codes/portfolio/nginx-site.conf
```

Copy it manually:
```bash
sudo cp ~/codes/portfolio/nginx-site.conf /etc/nginx/sites-available/angushsu.me
sudo ln -s /etc/nginx/sites-available/angushsu.me /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## 🔒 SSL/HTTPS Setup

### Automatic SSL (Recommended)

```bash
./scripts/deploy-pi.sh pi@raspberry.local --ssl --domain=angushsu.me
```

This will:
- Install certbot
- Obtain Let's Encrypt certificate
- Configure nginx for HTTPS
- Set up automatic renewal

### Manual SSL Setup

1. **Install certbot**:
   ```bash
   ssh pi@raspberry.local
   sudo apt install -y certbot python3-certbot-nginx
   ```

2. **Get certificate**:
   ```bash
   sudo certbot --nginx -d angushsu.me -d www.angushsu.me
   ```

3. **Setup auto-renewal**:
   ```bash
   echo "0 12 * * * /usr/bin/certbot renew --quiet" | sudo crontab -
   ```

## 📊 Management Commands

### Container Management

```bash
# Check status
ssh pi@raspberry.local 'cd ~/codes/portfolio && docker-compose ps'

# View logs
ssh pi@raspberry.local 'cd ~/codes/portfolio && docker-compose logs -f'

# Restart container
ssh pi@raspberry.local 'cd ~/codes/portfolio && docker-compose restart'

# Stop container
ssh pi@raspberry.local 'cd ~/codes/portfolio && docker-compose down'

# Start container
ssh pi@raspberry.local 'cd ~/codes/portfolio && docker-compose up -d'
```

### System Service Management

```bash
# Check service status
ssh pi@raspberry.local 'sudo systemctl status angus-portfolio'

# Start/stop service
ssh pi@raspberry.local 'sudo systemctl start angus-portfolio'
ssh pi@raspberry.local 'sudo systemctl stop angus-portfolio'

# Enable/disable auto-start
ssh pi@raspberry.local 'sudo systemctl enable angus-portfolio'
ssh pi@raspberry.local 'sudo systemctl disable angus-portfolio'
```

### Nginx Management

```bash
# Check nginx status
ssh pi@raspberry.local 'sudo systemctl status nginx'

# Test nginx configuration
ssh pi@raspberry.local 'sudo nginx -t'

# Reload nginx
ssh pi@raspberry.local 'sudo systemctl reload nginx'

# View nginx logs
ssh pi@raspberry.local 'sudo tail -f /var/log/nginx/access.log'
ssh pi@raspberry.local 'sudo tail -f /var/log/nginx/error.log'
```

## 🔄 Updates and Maintenance

### Update Deployment

To update your portfolio with new changes:

```bash
# Build and deploy latest version
./scripts/deploy-pi.sh pi@raspberry.local
```

### Backup and Restore

```bash
# Create backup on Pi
ssh pi@raspberry.local 'cd ~/codes/portfolio && docker-compose down && tar -czf backup-$(date +%Y%m%d).tar.gz .'

# Download backup
scp pi@raspberry.local:~/codes/portfolio/backup-*.tar.gz ./

# Restore backup (upload and extract)
scp backup-20231201.tar.gz pi@raspberry.local:~/codes/portfolio/
ssh pi@raspberry.local 'cd ~/codes/portfolio && tar -xzf backup-20231201.tar.gz && docker-compose up -d'
```

### System Maintenance

```bash
# Clean up old Docker images
ssh pi@raspberry.local 'docker system prune -a -f'

# Update system packages
ssh pi@raspberry.local 'sudo apt update && sudo apt upgrade -y'

# Check disk space
ssh pi@raspberry.local 'df -h'

# Check memory usage
ssh pi@raspberry.local 'free -h'
```

## 🐛 Troubleshooting

### Common Issues

**1. Container won't start**
```bash
# Check logs
ssh pi@raspberry.local 'cd ~/codes/portfolio && docker-compose logs'

# Check if port is in use
ssh pi@raspberry.local 'sudo netstat -tlnp | grep :611'

# Restart Docker
ssh pi@raspberry.local 'sudo systemctl restart docker'
```

**2. Nginx errors**
```bash
# Test nginx config
ssh pi@raspberry.local 'sudo nginx -t'

# Check nginx logs
ssh pi@raspberry.local 'sudo tail -f /var/log/nginx/error.log'

# Restart nginx
ssh pi@raspberry.local 'sudo systemctl restart nginx'
```

**3. SSL certificate issues**
```bash
# Check certificate status
ssh pi@raspberry.local 'sudo certbot certificates'

# Renew certificate manually
ssh pi@raspberry.local 'sudo certbot renew'

# Test auto-renewal
ssh pi@raspberry.local 'sudo certbot renew --dry-run'
```

**4. Memory issues**
```bash
# Check memory usage
ssh pi@raspberry.local 'free -h'

# Restart container with memory limit
ssh pi@raspberry.local 'cd ~/portfolio && docker-compose restart'

# Check container memory usage
ssh pi@raspberry.local 'docker stats angus-portfolio --no-stream'
```

### Health Checks

```bash
# Application health
curl -f http://your-pi-ip:611/
curl -f http://angushsu.me/

# Container health
ssh pi@raspberry.local 'docker ps'

# System health
ssh pi@raspberry.local 'uptime && free -h && df -h'
```

## 🎯 Performance Optimization

### For Raspberry Pi 4

The default configuration is optimized for Raspberry Pi 4 with:
- **Memory limit**: 512MB
- **CPU limit**: No limit (uses all available cores)
- **Disk optimization**: Volume mounts for logs

### For Raspberry Pi 3

For older Pi models, you might want to reduce memory usage:

```yaml
# In docker-compose.pi.yml
deploy:
  resources:
    limits:
      memory: 256M
    reservations:
      memory: 128M
```

## 🔐 Security Considerations

### Firewall Setup

```bash
ssh pi@raspberry.local
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 80
sudo ufw allow 443
```

### SSH Key Setup

```bash
# Generate SSH key (if you don't have one)
ssh-keygen -t rsa -b 4096

# Copy key to Pi
ssh-copy-id pi@raspberry.local
```

### Regular Updates

```bash
# Weekly system updates
ssh pi@raspberry.local 'sudo apt update && sudo apt upgrade -y'

# Monthly Docker cleanup
ssh pi@raspberry.local 'docker system prune -a -f'
```

## 📞 Support

If you encounter issues:

1. **Check logs**: Always start with container and nginx logs
2. **Verify connectivity**: Test SSH and web access
3. **Resource usage**: Check memory and disk space
4. **Configuration**: Validate nginx and Docker configs

For deployment script issues, run with verbose output:
```bash
bash -x ./scripts/deploy-pi.sh pi@raspberry.local
```

---

*Last updated: December 2024*