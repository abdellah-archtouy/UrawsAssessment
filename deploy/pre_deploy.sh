#!/bin/bash
set -e

echo "🔧 Pre-deployment setup"
echo "======================"

# Variables
DOMAIN="${DOMAIN:-aarchtou.me}"
EMAIL="${EMAIL:-admin@aarchtou.me}"

echo "Domain: $DOMAIN"
echo "Email: $EMAIL"

# Check if Certbot is installed
if ! command -v certbot >/dev/null 2>&1; then
    echo "🔐 Installing Certbot..."
    sudo apt update
    sudo apt install -y certbot python3-certbot-nginx
else
    echo "✅ Certbot already installed"
fi

# Create SSL directories
echo "📁 Creating SSL directories..."
mkdir -p /home/ubuntu/app/nginx/ssl
mkdir -p /home/ubuntu/app/certificates

# Check if we already have certificates
if [ ! -f "/home/ubuntu/app/nginx/ssl/fullchain.pem" ] || [ ! -f "/home/ubuntu/app/nginx/ssl/privkey.pem" ]; then
    echo "📜 Getting SSL certificate..."
    
    # Stop nginx container if running
    docker compose stop nginx 2>/dev/null || true
    
    # Get certificate using standalone mode
    sudo certbot certonly --standalone \
        -d "$DOMAIN" \
        -d "www.$DOMAIN" \
        --non-interactive \
        --agree-tos \
        --email "$EMAIL" \
        --http-01-port=8080 \
        --keep-until-expiring || {
            echo "⚠️ Certificate may already exist or Let's Encrypt rate limit hit"
            echo "Checking existing certificates..."
        }
    
    # Copy certificates
    if [ -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]; then
        echo "📋 Copying certificates..."
        sudo cp -L /etc/letsencrypt/live/$DOMAIN/fullchain.pem /home/ubuntu/app/nginx/ssl/
        sudo cp -L /etc/letsencrypt/live/$DOMAIN/privkey.pem /home/ubuntu/app/nginx/ssl/
        sudo chmod 644 /home/ubuntu/app/nginx/ssl/fullchain.pem
        sudo chmod 600 /home/ubuntu/app/nginx/ssl/privkey.pem
        sudo chown $USER:$USER /home/ubuntu/app/nginx/ssl/*
        echo "✅ Certificates copied successfully"
    else
        echo "⚠️ No certificates found, will use self-signed or HTTP only"
    fi
else
    echo "✅ SSL certificates already exist"
fi

# Create Nginx config for SSL
echo "🔧 Creating Nginx SSL configuration..."
cat > /home/ubuntu/app/nginx/nginx.conf << 'NGINX_CONFIG'
events {
    worker_connections 1024;
}

http {
    # HTTP to HTTPS redirect
    server {
        listen 80;
        server_name aarchtou.me www.aarchtou.me;
        return 301 https://$server_name$request_uri;
    }

    # HTTPS server
    server {
        listen 443 ssl http2;
        server_name aarchtou.me www.aarchtou.me;

        # SSL certificates (mounted from host)
        ssl_certificate /etc/nginx/ssl/fullchain.pem;
        ssl_certificate_key /etc/nginx/ssl/privkey.pem;
        
        # SSL settings
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
        ssl_prefer_server_ciphers off;
        
        # Security headers
        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";

        # Frontend
        location / {
            proxy_pass http://frontend:3000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # Backend API
        location /api {
            proxy_pass http://backend:5000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # Health check endpoint
        location /health {
            return 200 'OK';
            add_header Content-Type text/plain;
        }
    }
}
NGINX_CONFIG

echo "✅ Pre-deployment setup complete"