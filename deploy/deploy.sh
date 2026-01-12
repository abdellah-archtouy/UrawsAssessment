#!/bin/bash
set -e

echo "🚀 DEPLOYMENT EXECUTION"
echo "========================"
echo "Deployment SHA: $1"
echo "Starting at: $(date)"
echo ""

cd /opt/uraws

echo "1. Stopping existing containers..."
docker compose down || {
  echo "⚠️ Failed to stop containers, continuing anyway..."
}

echo "2. Pulling new Docker images..."
echo "   Images will be pulled from Docker Hub (public)"
docker compose pull || {
  echo "❌ Failed to pull images"
  exit 1
}

echo "3. Starting new containers..."
docker compose up -d || {
  echo "❌ Failed to start containers"
  exit 1
}

echo "4. Waiting for containers to start..."
sleep 10

echo "5. Checking container status..."
CONTAINER_STATUS=$(docker compose ps --services | while read service; do
  STATUS=$(docker compose ps -q "$service" | xargs docker inspect --format='{{.State.Status}}' 2>/dev/null || echo "not found")
  echo "   $service: $STATUS"
done)

echo "$CONTAINER_STATUS"

echo "6. Verifying all containers are running..."
ALL_RUNNING=$(docker compose ps --services | while read service; do
  docker compose ps -q "$service" | xargs docker inspect --format='{{.State.Status}}' 2>/dev/null | grep -q "running" || echo "not_running"
done | grep -c "not_running" || true)

if [ "$ALL_RUNNING" -eq 0 ]; then
  echo "✅ All containers are running"
else
  echo "⚠️ Some containers may not be running properly"
  docker compose ps
fi

echo "7. Cleaning up old images..."
OLD_IMAGES=$(docker images --filter "dangling=true" -q)
if [ -n "$OLD_IMAGES" ]; then
  docker rmi $OLD_IMAGES 2>/dev/null || true
  echo "✅ Cleaned up dangling images"
else
  echo "✅ No dangling images to clean"
fi

echo ""
echo "✅ DEPLOYMENT EXECUTION COMPLETED"
echo "========================"
echo "Completed at: $(date)"
echo ""

# Show final status
echo "📊 FINAL CONTAINER STATUS:"
docker compose ps --format "table {{.Name}}\t{{.Image}}\t{{.Status}}"