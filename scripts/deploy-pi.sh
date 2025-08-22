#!/bin/bash

# Deploy Angus Hsu Portfolio to Raspberry Pi
# Usage: ./scripts/deploy-pi.sh [pi_user@pi_host] [--setup] [--ssl]

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

# Default values
PI_HOST=""
SETUP_MODE=false
SSL_MODE=false
DOMAIN="angushsu.me"

# Parse arguments
for arg in "$@"; do
    case $arg in
        --setup)
            SETUP_MODE=true
            ;;
        --ssl)
            SSL_MODE=true
            ;;
        *@*)
            PI_HOST="$arg"
            ;;
        --domain=*)
            DOMAIN="${arg#*=}"
            ;;
    esac
done

if [[ -z "$PI_HOST" ]]; then
    echo -e "${RED}❌ Please provide Raspberry Pi host (user@hostname)${NC}"
    echo "Usage: ./scripts/deploy-pi.sh pi@raspberry.local [--setup] [--ssl]"
    exit 1
fi

echo -e "${PURPLE}🥧 Deploying Angus Hsu Portfolio to Raspberry Pi${NC}"
echo -e "${CYAN}Target: ${PI_HOST}${NC}"
echo -e "${CYAN}Domain: ${DOMAIN}${NC}"
echo ""

# Test SSH connection
echo -e "${YELLOW}🔗 Testing SSH connection...${NC}"
if ! ssh -o ConnectTimeout=10 "$PI_HOST" "echo 'SSH connection successful'" > /dev/null 2>&1; then
    echo -e "${RED}❌ Cannot connect to $PI_HOST${NC}"
    echo "Please ensure:"
    echo "  - SSH is enabled on Raspberry Pi"
    echo "  - SSH keys are set up or password is available"
    echo "  - Hostname/IP is correct"
    exit 1
fi
echo -e "${GREEN}✅ SSH connection successful${NC}"

# Setup mode - install dependencies
if [[ "$SETUP_MODE" == "true" ]]; then
    echo -e "${YELLOW}🛠️  Setting up Raspberry Pi environment...${NC}"
    
    ssh "$PI_HOST" << 'SETUP_EOF'
        set -e
        
        echo "📦 Updating package list..."
        sudo apt update
        
        echo "🐳 Installing Docker..."
        if ! command -v docker &> /dev/null; then
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            sudo usermod -aG docker $USER
            rm get-docker.sh
            echo "✅ Docker installed"
        else
            echo "✅ Docker already installed"
        fi
        
        echo "🐙 Installing Docker Compose..."
        if ! command -v docker-compose &> /dev/null; then
            sudo apt install -y docker-compose
            echo "✅ Docker Compose installed"
        else
            echo "✅ Docker Compose already installed"
        fi
        
        echo "🌐 Checking Nginx..."
        if ! command -v nginx &> /dev/null; then
            echo "❌ Nginx not found. Please install nginx first:"
            echo "sudo apt install -y nginx"
            exit 1
        else
            echo "✅ Nginx found"
        fi
        
        echo "📁 Creating directories..."
        mkdir -p ~/codes/portfolio
        mkdir -p ~/codes/portfolio/logs
        sudo mkdir -p /var/www/certbot
        
        echo "🔧 Setting up Docker permissions..."
        sudo systemctl enable docker
        sudo systemctl start docker
        
        echo "✅ Setup completed!"
SETUP_EOF
    
    echo -e "${GREEN}✅ Raspberry Pi setup completed${NC}"
    echo -e "${YELLOW}⚠️  Please log out and back in to apply Docker group permissions${NC}"
fi

# Build image locally for ARM architecture
echo -e "${YELLOW}🏗️  Building ARM64 image locally...${NC}"
docker buildx build --platform linux/arm64 -t angus-portfolio:arm64 . --load

# Save image to tar file
echo -e "${YELLOW}📦 Saving image to transfer...${NC}"
docker save angus-portfolio:arm64 | gzip > /tmp/angus-portfolio-arm64.tar.gz

# Create directory on Pi first
echo -e "${YELLOW}📁 Creating directory on Raspberry Pi...${NC}"
ssh "$PI_HOST" "mkdir -p ~/codes/portfolio"

# Transfer files to Pi
echo -e "${YELLOW}📤 Transferring files to Raspberry Pi...${NC}"

# Transfer image
echo "  Transferring Docker image..."
scp /tmp/angus-portfolio-arm64.tar.gz "$PI_HOST:~/codes/portfolio/"

# Transfer configuration files
echo "  Transferring configuration files..."
scp docker-compose.pi.yml "$PI_HOST:~/codes/portfolio/docker-compose.yml"
scp -r scripts/ "$PI_HOST:~/codes/portfolio/"
scp nginx-sites/angushsu.me "$PI_HOST:~/codes/portfolio/nginx-site.conf"

# Transfer environment files if they exist
if [[ -f ".env.production" ]]; then
    scp .env.production "$PI_HOST:~/codes/portfolio/.env"
fi

# Deploy on Pi
echo -e "${YELLOW}🚀 Deploying on Raspberry Pi...${NC}"

ssh "$PI_HOST" << EOF
    set -e
    cd ~/codes/portfolio
    
    echo "📥 Loading Docker image..."
    docker load < angus-portfolio-arm64.tar.gz
    rm angus-portfolio-arm64.tar.gz
    
    echo "🛑 Stopping existing containers..."
    docker-compose down 2>/dev/null || true
    
    echo "🚀 Starting new containers..."
    docker-compose up -d
    
    echo "⏳ Waiting for application to start..."
    sleep 10
    
    echo "🔍 Testing application..."
    if curl -f -s http://localhost:611/ > /dev/null; then
        echo "✅ Application is running on port 611"
    else
        echo "❌ Application failed to start"
        docker-compose logs
        exit 1
    fi
    
    echo "🧹 Cleaning up old images..."
    docker image prune -f
    
    echo "📊 Container status:"
    docker-compose ps
EOF

# Skip Nginx configuration for direct port access
echo -e "${YELLOW}ℹ️  Skipping Nginx configuration (using direct port access)${NC}"

# SSL Setup
if [[ "$SSL_MODE" == "true" ]]; then
    echo -e "${YELLOW}🔒 Setting up SSL with Let's Encrypt...${NC}"
    
    ssh "$PI_HOST" << EOF
        set -e
        
        echo "📦 Installing Certbot..."
        sudo apt install -y certbot python3-certbot-nginx
        
        echo "🔒 Obtaining SSL certificate..."
        sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN
        
        echo "⏰ Setting up auto-renewal..."
        echo "0 12 * * * /usr/bin/certbot renew --quiet" | sudo crontab -
        
        echo "✅ SSL configured successfully"
EOF
fi

# Create systemd service
echo -e "${YELLOW}⚙️  Creating systemd service...${NC}"

ssh "$PI_HOST" << 'SERVICE_EOF'
    set -e
    
    echo "📝 Creating systemd service..."
    sudo tee /etc/systemd/system/angus-portfolio.service > /dev/null << 'SERVICE'
[Unit]
Description=Angus Hsu Portfolio
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/pi/codes/portfolio
ExecStart=/usr/bin/docker-compose up -d
ExecStop=/usr/bin/docker-compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
SERVICE
    
    echo "🔄 Enabling service..."
    sudo systemctl daemon-reload
    sudo systemctl enable angus-portfolio.service
    
    echo "✅ Systemd service created"
SERVICE_EOF

# Cleanup local files
rm -f /tmp/angus-portfolio-arm64.tar.gz

# Final status check
echo -e "${YELLOW}🔍 Final deployment check...${NC}"

ssh "$PI_HOST" << EOF
    set -e
    
    echo "📊 Container status:"
    cd ~/codes/portfolio && docker-compose ps
    
    echo "🌐 Testing web access..."
    if curl -f -s http://localhost:611/ > /dev/null; then
        echo "✅ Portfolio application: OK"
    else
        echo "❌ Portfolio application: FAILED"
    fi
    
    echo "🔍 Nginx status:"
    sudo systemctl status nginx --no-pager -l
EOF

echo ""
echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
echo ""
echo -e "${CYAN}📋 Deployment Summary:${NC}"
echo -e "  🌐 Portfolio URL: http://$DOMAIN"
if [[ "$SSL_MODE" == "true" ]]; then
    echo -e "  🔒 HTTPS URL: https://$DOMAIN"
fi
echo -e "  🐳 Docker Container: Running on port 611 (publicly accessible)"
echo -e "  🌐 Direct Access: http://$PI_HOST:611"
echo -e "  ⚙️  Systemd Service: Enabled for auto-start"
echo ""
echo -e "${YELLOW}🛠️  Management Commands:${NC}"
echo -e "  Check status: ssh $PI_HOST 'cd ~/codes/portfolio && docker-compose ps'"
echo -e "  View logs: ssh $PI_HOST 'cd ~/codes/portfolio && docker-compose logs -f'"
echo -e "  Restart: ssh $PI_HOST 'cd ~/codes/portfolio && docker-compose restart'"
echo -e "  Update: ./scripts/deploy-pi.sh $PI_HOST"
echo ""
echo -e "${YELLOW}🔧 Nginx Commands:${NC}"
echo -e "  Check config: ssh $PI_HOST 'sudo nginx -t'"
echo -e "  Reload nginx: ssh $PI_HOST 'sudo systemctl reload nginx'"
echo -e "  Nginx logs: ssh $PI_HOST 'sudo tail -f /var/log/nginx/access.log'"