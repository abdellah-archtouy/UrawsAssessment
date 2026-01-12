#!/bin/bash
set -e

echo "🔍 PRE-DEPLOYMENT CHECKS"
echo "=========================="
echo "Deployment SHA: $1"
echo "Timestamp: $(date)"
echo ""

# Check if we're in the right directory
cd /opt/uraws || { echo "❌ /opt/uraws directory not found"; exit 1; }

echo "1. Checking Docker installation..."
docker --version || { echo "❌ Docker not installed"; exit 1; }
docker compose --version || { echo "❌ Docker Compose not installed"; exit 1; }

echo "2. Checking directory structure..."
ls -la

echo "3. Checking current containers..."
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"

echo "4. Creating backup of current configuration..."
if [ -f "docker compose.yml" ]; then
  BACKUP_FILE="docker compose.backup.$(date +%Y%m%d-%H%M%S).yml"
  cp docker compose.yml "$BACKUP_FILE"
  echo "✅ Backup created: $BACKUP_FILE"
else
  echo "⚠️ No existing docker compose.yml found"
fi

echo "5. Checking disk space..."
df -h / | tail -1

echo "6. Checking available memory..."
free -h

echo "7. Validating new docker compose.yml..."
if [ ! -f "docker compose.yml" ]; then
  echo "❌ docker compose.yml not found"
  exit 1
fi

# Test docker compose syntax
docker compose config --quiet || {
  echo "❌ Invalid docker compose.yml syntax"
  exit 1
}

echo "8. Checking for existing containers..."
EXISTING_CONTAINERS=$(docker compose ps -q 2>/dev/null | wc -l)
if [ "$EXISTING_CONTAINERS" -gt 0 ]; then
  echo "📊 Found $EXISTING_CONTAINERS existing container(s)"
fi

echo ""
echo "✅ PRE-DEPLOYMENT CHECKS COMPLETED"
echo "=========================="