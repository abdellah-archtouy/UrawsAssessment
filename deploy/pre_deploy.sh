#!/bin/bash
set -e

echo "[PRE_DEPLOY] Preparing deployment environment..."

# Create app folder if it doesn't exist
mkdir -p /home/ubuntu/liztd-test

# Set correct permissions
chown -R ubuntu:ubuntu /home/ubuntu/liztd-test
chmod -R 755 /home/ubuntu/liztd-test

echo "[PRE_DEPLOY] Environment ready."

