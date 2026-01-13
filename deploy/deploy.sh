#!/bin/bash
set -e

echo "🚀 Starting deployment"

# ==============================
# Paths & configuration
# ==============================
DEPLOY_DIR="/home/ubuntu/deploy"   # where this deploy.sh lives
APP_DIR="/home/ubuntu/repo"         # your app files
DOMAIN="aarchtou.me"
EMAIL="admin@aarchtou.me"

CERT_PATH="/etc/letsencrypt/live/${DOMAIN}/fullchain.pem"

# ==============================
# Make sure we are in deploy dir
# ==============================
cd "$DEPLOY_DIR"

# ==============================
# Pull latest release branch
# ==============================
# echo "📦 Fetching latest release branch"
# git fetch origin release
# git checkout release
# git pull origin release
echo "📦 Skipping git pull (assuming latest code is already in place)"
# ==============================
# Stop old containers
# ==============================
echo "🐳 Stopping old containers"
docker compose -f "$APP_DIR/docker-compose.yml" down || true

# ==============================
# Build & start containers
# ==============================
echo "🐳 Building and starting containers"
docker compose -f "$APP_DIR/docker-compose.yml" up -d --build mysql backend frontend nginx

# ==============================
# Wait for backend
# ==============================
echo "⏳ Waiting for backend to be ready"
sleep 10

# ==============================
# Prisma migration (SAFE)
# ==============================
echo "🛠️ Running Prisma migrations"
docker compose -f "$APP_DIR/docker-compose.yml" exec backend npx prisma migrate deploy \
  || docker compose -f "$APP_DIR/docker-compose.yml" exec backend npx prisma db push

echo "✅ Prisma migration done"

# ==============================
# SSL certificate (ONLY if missing)
# ==============================
if [ ! -f "$CERT_PATH" ]; then
  echo "🔐 SSL certificate not found — generating..."

  docker compose -f "$APP_DIR/docker-compose.yml" stop nginx || true

  docker compose -f "$APP_DIR/docker-compose.yml" run --rm certbot certonly \
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

# ==============================
# Restart nginx
# ==============================
echo "🔄 Restarting nginx"
docker compose -f "$APP_DIR/docker-compose.yml" restart nginx

echo "✅ Deployment completed successfully"
