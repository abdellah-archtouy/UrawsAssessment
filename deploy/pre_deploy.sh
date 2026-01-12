#!/bin/bash
set -e

echo "🔍 PRE-DEPLOYMENT CHECKS"
echo "========================"
echo "Image Tag: $1"
echo "Timestamp: $(date)"
echo ""

cd /opt/uraws || { echo "Creating /opt/uraws directory"; mkdir -p /opt/uraws; cd /opt/uraws; }

echo "1. Checking Docker installation..."
docker --version || { echo "❌ Docker not installed"; exit 1; }
docker-compose --version || { echo "❌ Docker Compose not installed"; exit 1; }

echo "2. Checking disk space..."
df -h / | tail -1

echo "3. Checking memory..."
free -h | head -2

echo "4. Creating backup..."
if [ -f "docker-compose.yml" ]; then
  BACKUP="docker-compose.backup.$(date +%Y%m%d-%H%M%S).yml"
  cp docker-compose.yml "$BACKUP"
  echo "✅ Backup created: $BACKUP"
else
  echo "⚠️ No existing docker-compose.yml found"
fi

echo ""
echo "✅ PRE-DEPLOYMENT CHECKS COMPLETE"