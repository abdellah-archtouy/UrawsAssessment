#!/bin/bash
set -e

echo "🚀 Starting deployment"
echo "======================"

# Variables
DOMAIN="${DOMAIN:-aarchtou.me}"
EMAIL="${EMAIL:-admin@aarchtou.me}"
DB_PASSWORD="${DB_PASSWORD:-rootpassword}"

cd /home/ubuntu/app

echo "📦 Pulling latest code..."
git pull origin release

echo "🔧 Setting up environment..."

# Create .env file for backend
cat > .env << EOF
DATABASE_URL=mysql://root:${DB_PASSWORD}@mysql:3306/userdb
PORT=5000
NODE_ENV=production
CORS_ORIGIN=*
EOF

echo "🐳 Starting containers..."
docker-compose down 2>/dev/null || true
docker-compose up -d --build

echo "⏳ Waiting for services to start..."
sleep 30

echo "✅ Deployment step completed"