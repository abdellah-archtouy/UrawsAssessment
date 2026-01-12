#!/bin/bash
set -e

echo "🚀 DEPLOYMENT EXECUTION"
echo "======================="
echo "Image Tag: $1"
echo "Starting at: $(date)"
echo ""

cd /opt/uraws

echo "1. Updating image tags in docker-compose.yml..."
sed -i "s|aarchtou/youraws-backend:latest|aarchtou/youraws-backend:$1|g" docker-compose.yml
sed -i "s|aarchtou/youraws-frontend:latest|aarchtou/youraws-frontend:$1|g" docker-compose.yml

echo "2. Pulling new images from Docker Hub..."
docker compose pull || {
  echo "❌ Failed to pull images"
  echo "Trying to build locally..."
  exit 1
}

echo "3. Stopping existing containers..."
docker compose down || true

echo "4. Starting new containers..."
docker compose up -d || {
  echo "❌ Failed to start containers"
  exit 1
}

echo "5. Waiting for services to start..."
sleep 20

echo "6. Checking container status..."
docker compose ps

echo "7. Cleaning up old images..."
docker image prune -af 2>/dev/null || true

echo ""
echo "✅ DEPLOYMENT COMPLETED"
echo "Completed at: $(date)"