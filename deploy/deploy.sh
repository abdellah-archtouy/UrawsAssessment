#!/bin/bash
set -e

echo "🚀 Starting deployment"

APP_DIR="/home/ubuntu/repo"
cd "$APP_DIR"

# Stop old containers
echo "🐳 Stopping old containers"
sudo docker compose down || true

# Pull latest images
echo "📦 Pulling latest images"
sudo docker compose pull

# Start core services
echo "🐳 Starting services"
sudo docker compose up -d mysql backend frontend nginx

# Wait for backend health
echo "⏳ Waiting for backend"
sleep 10

echo "✅ Deployment completed successfully"
# Run database migrations
echo "🛠️ Running database migrations "
sudo docker compose exec backend npx prisma migrate deploy || sudo docker compose exec backend npx prisma db push
echo "✅ Database migrations completed successfully"
