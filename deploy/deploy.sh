#!/bin/bash
set -e

echo "[DEPLOY] Starting deployment..."

# Folder for releases/backups
mkdir -p /home/ubuntu/releases

# Timestamped release ID
RELEASE_ID=$(date +%Y%m%d%H%M%S)
export RELEASE_ID

# Backup previous deployment if exists
if [ -d /home/ubuntu/liztd-test ]; then
    echo "[DEPLOY] Backing up current deployment..."
    rsync -a /home/ubuntu/liztd-test/ /home/ubuntu/releases/liztd-$RELEASE_ID/
    echo "[DEPLOY] Backup created at /home/ubuntu/releases/liztd-$RELEASE_ID"
fi

# Pull latest code from main branch (for test, we will just copy local repo files)
echo "[DEPLOY] Pulling latest code..."
mkdir -p /home/ubuntu/liztd-test
rsync -a ../frontend/ ../backend/ /home/ubuntu/liztd-test/

# For now, just print (Docker compose build will come later)
echo "[DEPLOY] Code copied to /home/ubuntu/liztd-test"
echo "[DEPLOY] Deployment complete."
