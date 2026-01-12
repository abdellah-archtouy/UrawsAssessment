#!/bin/bash
set -e

echo "🔍 POST-DEPLOYMENT VERIFICATION"
echo "================================"
echo "Deployment SHA: $1"
echo "Verification started: $(date)"
echo ""

cd /opt/uraws

echo "1. Checking all containers are healthy..."
sleep 5

# Check each service health
SERVICES="backend frontend mysql nginx"
ALL_HEALTHY=true

for SERVICE in $SERVICES; do
  echo "   Checking $SERVICE..."
  
  case $SERVICE in
    backend)
      if curl -s -f http://localhost:5000/health > /dev/null; then
        echo "     ✅ Backend health check passed"
      else
        echo "     ❌ Backend health check failed"
        ALL_HEALTHY=false
      fi
      ;;
      
    frontend)
      # Frontend doesn't have a health endpoint, check if container is running
      if docker compose ps frontend | grep -q "Up"; then
        echo "     ✅ Frontend container is running"
      else
        echo "     ❌ Frontend container is not running"
        ALL_HEALTHY=false
      fi
      ;;
      
    mysql)
      if docker compose exec mysql mysqladmin ping -h localhost --silent; then
        echo "     ✅ MySQL is responsive"
      else
        echo "     ❌ MySQL is not responsive"
        ALL_HEALTHY=false
      fi
      ;;
      
    nginx)
      if docker compose exec nginx nginx -t > /dev/null 2>&1; then
        echo "     ✅ Nginx configuration is valid"
      else
        echo "     ❌ Nginx configuration is invalid"
        ALL_HEALTHY=false
      fi
      
      # Check nginx is serving
      if curl -s -f http://localhost > /dev/null; then
        echo "     ✅ Nginx is serving on port 80"
      else
        echo "     ❌ Nginx is not serving on port 80"
        ALL_HEALTHY=false
      fi
      ;;
  esac
done

echo ""
echo "2. Testing application endpoints..."

# Test API endpoint
echo "   Testing API endpoint..."
API_RESPONSE=$(curl -s http://localhost/api/users || echo "failed")
if [ "$API_RESPONSE" != "failed" ]; then
  echo "     ✅ API is responding"
else
  echo "     ❌ API is not responding"
  ALL_HEALTHY=false
fi

# Test frontend endpoint
echo "   Testing frontend endpoint..."
FRONTEND_RESPONSE=$(curl -s -I http://localhost 2>/dev/null | head -1 | cut -d' ' -f2)
if [ "$FRONTEND_RESPONSE" = "200" ] || [ "$FRONTEND_RESPONSE" = "304" ]; then
  echo "     ✅ Frontend is responding (HTTP $FRONTEND_RESPONSE)"
else
  echo "     ❌ Frontend is not responding (HTTP $FRONTEND_RESPONSE)"
  ALL_HEALTHY=false
fi

echo ""
echo "3. Checking resource usage..."

echo "   Container resource usage:"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" | head -10

echo "   Disk space:"
df -h / | tail -1

echo ""
echo "4. Deployment summary:"

# Get image versions
echo "   Deployed image versions:"
docker compose images | tail -n +2 | while read line; do
  SERVICE=$(echo $line | awk '{print $1}')
  IMAGE=$(echo $line | awk '{print $2}')
  echo "     $SERVICE: $IMAGE"
done

echo ""
if [ "$ALL_HEALTHY" = true ]; then
  echo "✅ POST-DEPLOYMENT VERIFICATION PASSED"
  echo "================================"
  echo "All systems are operational"
  echo "Deployment SHA: $1"
  echo "Completed at: $(date)"
else
  echo "❌ POST-DEPLOYMENT VERIFICATION FAILED"
  echo "================================"
  echo "Some checks failed. Please investigate."
  echo ""
  echo "Debug information:"
  docker compose logs --tail=20
  exit 1
fi