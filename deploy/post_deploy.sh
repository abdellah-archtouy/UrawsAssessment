#!/bin/bash
set -e

echo "🔍 POST-DEPLOYMENT VERIFICATION"
echo "================================"
echo "Image Tag: $1"
echo "Started at: $(date)"
echo ""

cd /opt/uraws

echo "1. Checking all containers are running..."
ALL_RUNNING=true
for service in mysql backend frontend nginx; do
  if docker-compose ps $service | grep -q "Up"; then
    echo "✅ $service is running"
  else
    echo "❌ $service is NOT running"
    ALL_RUNNING=false
  fi
done

echo ""
echo "2. Testing application endpoints..."

echo "   Testing backend health..."
if curl -s -f http://localhost:5000/health > /dev/null; then
  echo "   ✅ Backend health check passed"
else
  echo "   ❌ Backend health check failed"
  ALL_RUNNING=false
fi

echo "   Testing frontend via nginx..."
if curl -s -f http://localhost > /dev/null; then
  echo "   ✅ Frontend is accessible"
else
  echo "   ❌ Frontend is not accessible"
  ALL_RUNNING=false
fi

echo "   Testing API endpoint..."
API_RESPONSE=$(curl -s http://localhost/api/users | head -c 50)
if [ -n "$API_RESPONSE" ]; then
  echo "   ✅ API is responding"
else
  echo "   ❌ API is not responding"
  ALL_RUNNING=false
fi

echo ""
if [ "$ALL_RUNNING" = true ]; then
  echo "🎉 DEPLOYMENT SUCCESSFUL!"
  echo "All services are running correctly."
  echo "Deployed tag: $1"
else
  echo "⚠️ Some services may have issues."
  echo "Check logs with: docker-compose logs"
  exit 1
fi

echo ""
echo "✅ POST-DEPLOYMENT VERIFICATION COMPLETE"
echo "Completed at: $(date)"