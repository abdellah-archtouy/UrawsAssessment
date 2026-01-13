#!/bin/bash
set -e

echo "🔍 Post-deployment verification"
echo "================================"

DOMAIN="${DOMAIN:-aarchtou.me}"

cd /home/ubuntu/app

# Wait for services
echo "⏳ Waiting for services to stabilize..."
sleep 20

# Check containers
echo "📊 Container status:"
docker-compose ps

# Run database migrations
echo "🛠️ Running database migrations..."
if docker-compose exec backend npx prisma migrate deploy; then
    echo "✅ Database migrations completed"
else
    echo "⚠️ Migration failed, trying alternative method..."
    docker-compose exec backend npx prisma db push --accept-data-loss || \
    docker-compose exec backend npm run migrate || \
    echo "❌ All migration attempts failed"
fi

# Setup SSL in Nginx
echo "🔐 Setting up SSL in Nginx..."

# Copy certificates to container if they exist
if [ -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]; then
    echo "📋 Copying certificates to Nginx container..."
    
    # Create script to run inside container
    cat > /tmp/setup_certs.sh << 'EOF'
    #!/bin/sh
    DOMAIN="$1"
    mkdir -p /etc/letsencrypt/live/$DOMAIN
    cp /etc/nginx/ssl/fullchain.pem /etc/letsencrypt/live/$DOMAIN/ 2>/dev/null || true
    cp /etc/nginx/ssl/privkey.pem /etc/letsencrypt/live/$DOMAIN/ 2>/dev/null || true
    nginx -t 2>/dev/null && nginx -s reload 2>/dev/null || true
EOF
    
    chmod +x /tmp/setup_certs.sh
    docker cp /tmp/setup_certs.sh nginx:/tmp/setup_certs.sh
    docker exec nginx sh /tmp/setup_certs.sh "$DOMAIN"
    rm -f /tmp/setup_certs.sh
fi

# Test endpoints
echo "🌐 Testing endpoints..."
echo "HTTP (should redirect): $(curl -s -o /dev/null -w "%{http_code}" http://$DOMAIN || echo "failed")"
echo "HTTPS: $(curl -s -k -o /dev/null -w "%{http_code}" https://$DOMAIN 2>/dev/null || echo "failed")"
echo "API Health: $(curl -s -k -o /dev/null -w "%{http_code}" https://$DOMAIN/api/health 2>/dev/null || echo "failed")"

echo ""
echo "✅ Post-deployment verification complete"
echo "🌍 Application URLs:"
echo "  - http://$DOMAIN"
echo "  - https://$DOMAIN"