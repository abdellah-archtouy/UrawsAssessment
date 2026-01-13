#!/bin/bash
set -e

echo "🔍 Post-deployment verification"
echo "==============================="

# Variables
DOMAIN="${DOMAIN:-aarchtou.me}"

# Wait a bit for services to fully start
echo "⏳ Waiting for services to stabilize..."
sleep 20

# Check container status
echo "📊 Checking container status:"
docker compose ps

# Check if all containers are running
RUNNING_CONTAINERS=$(docker compose ps --services --filter "status=running")
TOTAL_CONTAINERS=$(docker compose ps --services | wc -l)

if [ "$RUNNING_CONTAINERS" -eq "$TOTAL_CONTAINERS" ]; then
    echo "✅ All containers are running"
else
    echo "⚠️ Some containers may not be running properly"
    docker compose ps
fi

# Test HTTP (should redirect to HTTPS)
echo ""
echo "🌐 Testing HTTP (should redirect to HTTPS):"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://$DOMAIN || echo "000")
if [ "$HTTP_STATUS" = "301" ] || [ "$HTTP_STATUS" = "302" ]; then
    echo "✅ HTTP redirect is working (Status: $HTTP_STATUS)"
else
    echo "⚠️ HTTP redirect may not be working (Status: $HTTP_STATUS)"
fi

# Test HTTPS
echo ""
echo "🔒 Testing HTTPS:"
HTTPS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN 2>/dev/null || echo "000")
if [ "$HTTPS_STATUS" = "200" ] || [ "$HTTPS_STATUS" = "301" ] || [ "$HTTPS_STATUS" = "302" ]; then
    echo "✅ HTTPS is working (Status: $HTTPS_STATUS)"
else
    echo "⚠️ HTTPS may not be working (Status: $HTTPS_STATUS)"
    
    # Try localhost as fallback
    HTTPS_LOCAL=$(curl -s -o /dev/null -w "%{http_code}" https://localhost 2>/dev/null || echo "000")
    if [ "$HTTPS_LOCAL" = "200" ] || [ "$HTTPS_LOCAL" = "301" ] || [ "$HTTPS_LOCAL" = "302" ]; then
        echo "ℹ️  HTTPS works on localhost (Status: $HTTPS_LOCAL)"
    fi
fi

# Check SSL certificate
echo ""
echo "📜 Checking SSL certificate:"
if [ -f "/home/ubuntu/app/nginx/ssl/fullchain.pem" ]; then
    echo "✅ SSL certificate found"
    # Show certificate expiry
    openssl x509 -in /home/ubuntu/app/nginx/ssl/fullchain.pem -noout -dates 2>/dev/null || echo "Could not read certificate details"
else
    echo "⚠️ SSL certificate not found in app directory"
    
    # Check system certificates
    if [ -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]; then
        echo "ℹ️  Certificate found in system location"
    fi
fi

# Display nginx logs (last 10 lines)
echo ""
echo "📋 Nginx container logs (last 10 lines):"
docker compose logs nginx --tail=10

# Display application URLs
echo ""
echo "🌍 Application URLs:"
echo "   HTTP:  http://$DOMAIN"
echo "   HTTPS: https://$DOMAIN"
echo "   Local: http://localhost"
echo ""
echo "✅ Post-deployment verification complete"