#!/bin/bash
set -e

echo "🔧 Pre-deployment setup"
echo "======================"

DOMAIN="${DOMAIN:-aarchtou.me}"
EMAIL="${EMAIL:-admin@aarchtou.me}"

echo "Domain: $DOMAIN"
echo "Email: $EMAIL"

# Check if Docker and Docker Compose are installed
echo "🐳 Checking Docker installation..."
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    newgrp docker
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    sudo apt update
    sudo apt install -y docker-compose-plugin
fi

# Install Certbot if not installed
echo "🔐 Checking Certbot installation..."
if ! command -v certbot >/dev/null 2>&1; then
    echo "Installing Certbot..."
    sudo apt update
    sudo apt install -y certbot python3-certbot-nginx
fi

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p /home/ubuntu/app/certificates
mkdir -p /home/ubuntu/app/certbot/www
mkdir -p /home/ubuntu/app/nginx

echo "✅ Pre-deployment setup complete"