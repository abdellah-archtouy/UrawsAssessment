#!/bin/bash
set -e

echo "🚀 Starting deployment"

# ==============================
# Paths & config
# ==============================
APP_DIR="/home/ubuntu/repo"
DOMAIN="aarchtou.me"
EMAIL="admin@aarchtou.me"

CERT_PATH="$APP_DIR/certbot/conf/live/${DOMAIN}/fullchain.pem"

cd "$APP_DIR"

# ==============================
# Stop old containers
# ==============================
echo "🐳 Stopping old containers"
docker compose down || true

# ==============================
# Pull latest images
# ==============================
echo "📦 Pulling latest images"
docker compose pull

# ==============================
# Start core services
# ==============================
echo "🐳 Starting services"
docker compose up -d mysql backend frontend nginx

# ==============================
# Wait for backend health
# ==============================
echo "⏳ Waiting for backend"
sleep 10

# ==============================
# SSL certificate (only once)
# ==============================
if [ ! -f "$CERT_PATH" ]; then
  echo "🔐 SSL certificate not found — generating"

  docker compose stop nginx || true

  docker compose run --rm certbot certonly \
    --webroot \
    --webroot-path /var/www/certbot \
    -d "$DOMAIN" -d "www.$DOMAIN" \
    --email "$EMAIL" \
    --agree-tos \
    --non-interactive

  echo "✅ SSL certificate generated"
else
  echo "🔒 SSL certificate already exists"
fi

# ==============================
# Restart nginx
# ==============================
echo "🔄 Restarting nginx"
docker compose restart nginx

echo "✅ Deployment completed successfully"
