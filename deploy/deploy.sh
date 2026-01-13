#!/bin/bash
set -e

echo "🚀 Deploying application"
echo "======================="

# Go to app directory
cd /home/ubuntu/app

# Update docker-compose.yml if needed for SSL
echo "🔧 Configuring Docker Compose for SSL..."
if [ -f "docker-compose.yml" ]; then
    # Check if SSL volume mount exists
    if ! grep -q "nginx/ssl" docker-compose.yml; then
        echo "➕ Adding SSL volume mount..."
        
        # Create backup
        cp docker-compose.yml docker-compose.yml.backup
        
        # Update nginx service to include SSL volume
        cat > docker-compose.yml << 'DOCKER_COMPOSE'
version: '3.8'

services:
  nginx:
    image: nginx:alpine
    container_name: nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/ssl:/etc/nginx/ssl:ro
    depends_on:
      - frontend
      - backend
    restart: unless-stopped

  frontend:
    build: ./frontend
    container_name: frontend
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production

  backend:
    build: ./backend
    container_name: backend
    ports:
      - "5000:5000"
    environment:
      - DB_HOST=database

  database:
    image: postgres:14
    container_name: database
    environment:
      - POSTGRES_PASSWORD=yourpassword
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
DOCKER_COMPOSE
    fi
fi

# Deploy with Docker Compose
echo "🐳 Starting containers..."
docker compose down 2>/dev/null || true
docker compose up -d --build

echo "✅ Application deployed successfully"