#!/bin/bash

# Setup SSL proxy for portfolio on port 611
# Usage: ./scripts/setup-ssl-proxy.sh pi@raspberry.local portfolio.angushsu.me

set -e

PI_HOST="$1"
DOMAIN="$2"

if [[ -z "$PI_HOST" || -z "$DOMAIN" ]]; then
    echo "❌ Usage: $0 pi@raspberry.local portfolio.angushsu.me"
    exit 1
fi

echo "🔒 Setting up SSL proxy for $DOMAIN on $PI_HOST"

# Transfer nginx config
echo "📤 Transferring SSL proxy configuration..."
scp nginx-ssl-proxy.conf "$PI_HOST:~/portfolio-ssl.conf"

# Setup SSL certificate and nginx
ssh "$PI_HOST" << EOF
    set -e
    
    echo "📦 Installing certbot..."
    sudo apt update
    sudo apt install -y certbot python3-certbot-nginx
    
    echo "📋 Installing nginx configuration..."
    sudo cp ~/portfolio-ssl.conf /etc/nginx/sites-available/portfolio-ssl
    
    echo "🔗 Enabling site..."
    sudo ln -sf /etc/nginx/sites-available/portfolio-ssl /etc/nginx/sites-enabled/
    
    echo "🧪 Testing nginx configuration..."
    sudo nginx -t
    
    echo "🔄 Reloading nginx..."
    sudo systemctl reload nginx
    
    echo "🔒 Obtaining SSL certificate for $DOMAIN..."
    sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN
    
    echo "⏰ Setting up certificate renewal..."
    echo "0 12 * * * /usr/bin/certbot renew --quiet" | sudo crontab -
    
    echo "✅ SSL proxy configured successfully!"
    echo "🌐 Your portfolio is now available at:"
    echo "  - HTTPS: https://$DOMAIN"
    echo "  - Direct: http://$(hostname -I | awk '{print \$1}'):611"
EOF

echo ""
echo "🎉 SSL setup completed!"
echo "📝 Next steps:"
echo "  1. Point $DOMAIN DNS to your public IP"
echo "  2. Wait for DNS propagation"
echo "  3. Access: https://$DOMAIN"
echo ""
echo "🔍 Both access methods work:"
echo "  - SSL: https://$DOMAIN"
echo "  - Direct: http://your-ip:611"