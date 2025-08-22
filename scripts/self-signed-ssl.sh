#!/bin/bash

# Create self-signed SSL certificate for development
# Usage: ./scripts/self-signed-ssl.sh pi@raspberry.local

PI_HOST="$1"

if [[ -z "$PI_HOST" ]]; then
    echo "❌ Usage: $0 pi@raspberry.local"
    exit 1
fi

echo "🔒 Setting up self-signed SSL certificate..."

ssh "$PI_HOST" << 'EOF'
    set -e
    
    echo "📁 Creating SSL directory..."
    sudo mkdir -p /etc/nginx/ssl
    
    echo "🔑 Generating self-signed certificate..."
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/portfolio.key \
        -out /etc/nginx/ssl/portfolio.crt \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
    
    echo "📋 Creating nginx SSL config..."
    sudo tee /etc/nginx/sites-available/portfolio-ssl > /dev/null << 'NGINX_CONF'
server {
    listen 8443 ssl;
    server_name _;
    
    ssl_certificate /etc/nginx/ssl/portfolio.crt;
    ssl_certificate_key /etc/nginx/ssl/portfolio.key;
    
    location / {
        proxy_pass http://127.0.0.1:611;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
NGINX_CONF
    
    echo "🔗 Enabling SSL site..."
    sudo ln -sf /etc/nginx/sites-available/portfolio-ssl /etc/nginx/sites-enabled/
    
    echo "🧪 Testing nginx config..."
    sudo nginx -t
    
    echo "🔄 Reloading nginx..."
    sudo systemctl reload nginx
    
    echo "✅ Self-signed SSL setup complete!"
    echo "🌐 Access via HTTPS: https://$(hostname -I | awk '{print $1}'):8443"
    echo "⚠️  Browser will show security warning (click 'Advanced' -> 'Proceed')"
EOF