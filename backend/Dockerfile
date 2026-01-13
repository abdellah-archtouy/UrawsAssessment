# Backend Dockerfile
FROM node:18-alpine

# Install OpenSSL and bash for Prisma
RUN apk add --no-cache openssl bash

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY prisma ./prisma/

# Install dependencies
RUN npm install --production

# Generate Prisma Client
RUN npx prisma generate

# Copy source code
COPY src ./src

# Expose backend port
EXPOSE 5000

# Start the application
CMD ["sh", "-c", "npx prisma migrate deploy && node src/server.js"]
