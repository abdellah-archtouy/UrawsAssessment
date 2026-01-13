#!/bin/bash
set -e

echo "🚀 Starting deployment"

APP_DIR="/home/ubuntu/app"
DOMAIN="aarchtou.me"
EMAIL="admin@aarchtou.me"

CERT_PATH="/etc/letsencrypt/live/${DOMAIN}/fullchain.pem"

cd "$APP_DIR"

echo "🐳 Stopping old containers"
docker compose down  || true

echo "🐳 Building and starting containers"
docker compose up -d --build mysql backend frontend nginx

echo "⏳ Waiting for backend to be ready"
sleep 10

# ==============================
# Prisma migration (SAFE)
# ==============================
echo "🛠️ Running Prisma migrations"

docker compose exec backend npx prisma migrate deploy \
  || docker compose exec backend npx prisma db push

echo "✅ Prisma migration done"

# ==============================
# SSL certificate (ONLY if missing)
# ==============================
if [ ! -f "$CERT_PATH" ]; then
  echo "🔐 SSL certificate not found — generating..."

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
  echo "🔒 SSL certificate already exists — skipping"
fi

echo "🔄 Restarting nginx"
docker compose restart nginx

echo "✅ Deployment completed successfully"
