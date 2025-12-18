#!/bin/bash
set -e

echo "Deploying YourAWS User Management Application..."

echo "Pulling images from Docker Hub..."
docker-compose pull

echo "Stopping existing containers..."
docker-compose down

echo "Starting services..."
docker-compose up -d

echo "Waiting for services to be healthy..."
sleep 10
echo "Checking service status..."
docker-compose ps

echo ""
echo "Deployment complete!"
echo ""
echo "Application is running on port 80"
echo "Access at: http://YOUR_VPS_IP"
echo ""
echo "View logs:"
echo "  docker-compose logs -f"
echo ""
echo "Useful commands:"
echo "  docker-compose ps          # Check status"
echo "  docker-compose logs -f     # View logs"
echo "  docker-compose down        # Stop all services"
echo "  docker-compose restart     # Restart services"
