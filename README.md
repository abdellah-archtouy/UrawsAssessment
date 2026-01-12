# User Management System - YourAWS Technical Assessment

A full-stack user management application with React frontend, Node.js/Express backend, MySQL database, fully containerized with Docker and deployable to any VPS.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    VPS (Port 80)                        │
│  ┌───────────────────────────────────────────────────┐  │
│  │              Nginx Reverse Proxy                  │  │
│  └──────────┬────────────────────────┬───────────────┘  │
│             │                        │                  │
│    ┌────────▼────────┐      ┌───────▼────────┐          │
│    │  Frontend:3000  │      │  Backend:5000   │         │
│    │  (React + Vite) │      │  (Express API)  │         │
│    └─────────────────┘      └────────┬────────┘         │
│                                      │                  │
│                             ┌────────▼────────┐         │
│                             │  MySQL:3306     │         │
│                             │  (Persistent)   │         │
│                             └─────────────────┘         │
│                                                         │
│  Network: app-network (internal Docker network)         │
└─────────────────────────────────────────────────────────┘
```

## 🎯 Features

### Frontend (React SPA)
- ✅ User List page with create functionality
- ✅ User Details page with edit/delete
- ✅ **TanStack Query for intelligent caching** (bonus requirement!)
- ✅ Responsive design with modern UI
- ✅ Form validation and error handling
- ✅ Client-side routing with React Router

### Backend (Node.js/Express)
- ✅ RESTful CRUD API with 5 endpoints
- ✅ Prisma ORM for type-safe database access
- ✅ Input validation with express-validator
- ✅ Error handling middleware
- ✅ CORS and security headers (Helmet)
- ✅ Database migrations

### Database (MySQL)
- ✅ Persistent storage with Docker volumes
- ✅ Proper schema with constraints
- ✅ Automatic migrations on deployment

### Docker & Deployment
- ✅ Multi-container setup with docker compose
- ✅ **Only port 80 exposed** (requirement met!)
- ✅ All containers on same network
- ✅ Health checks for reliability
- ✅ Images pushed to Docker Hub

## 🛠️ Technology Stack

### Why This Stack?

**Frontend: React + Vite**
- ⚡ Lightning-fast dev server and builds
- 🎯 Industry standard with huge community
- 🔥 Hot Module Replacement for best DX

**State Management: TanStack Query**
- 🚀 Automatic caching and refetching (bonus requirement!)
- 🎯 Reduces server load significantly
- ✅ Built-in loading and error states

**Backend: Node.js + Express**
- 🏃 Fast, scalable, and non-blocking
- 📦 Huge ecosystem of packages
- 🔧 Simple to containerize

**ORM: Prisma**
- 🔒 Type-safe database queries
- 🔄 Automatic migrations
- 📊 Great developer experience

**Database: MySQL 8.0**
- 💾 Reliable and proven
- 🔐 ACID compliance
- 📈 Excellent performance

**Reverse Proxy: Nginx**
- ⚡ High-performance load balancing
- 🔀 Routes traffic on port 80
- 📦 Tiny footprint (Alpine image)

## 📋 API Endpoints

| Method | Endpoint        | Description       | Request Body                          |
|--------|-----------------|-------------------|---------------------------------------|
| GET    | `/api/users`    | Get all users     | -                                     |
| GET    | `/api/users/:id`| Get single user   | -                                     |
| POST   | `/api/users`    | Create user       | `{ firstname, lastname, email }`      |
| PUT    | `/api/users/:id`| Update user       | `{ firstname, lastname, email }`      |
| DELETE | `/api/users/:id`| Delete user       | -                                     |
| GET    | `/health`       | Health check      | -                                     |

### Example Requests

```bash
# Get all users
curl http://YOUR_VPS_IP/api/users

# Create a user
curl -X POST http://YOUR_VPS_IP/api/users \
  -H "Content-Type: application/json" \
  -d '{"firstname":"John","lastname":"Doe","email":"john@example.com"}'

# Update a user
curl -X PUT http://YOUR_VPS_IP/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{"firstname":"Jane","lastname":"Doe","email":"jane@example.com"}'

# Delete a user
curl -X DELETE http://YOUR_VPS_IP/api/users/1

# Health check
curl http://YOUR_VPS_IP/health
```

## 🚀 Local Development

### Prerequisites
- Node.js 18+ and npm
- Docker and Docker Compose
- Git

### Quick Start

1. **Clone the repository**
```bash
git clone <your-repo-url>
cd UrawsAssessment
```

2. **Install dependencies**
```bash
# Backend
cd backend
npm install
cd ..

# Frontend
cd frontend
npm install
cd ..
```

3. **Set up environment variables**
```bash
cp .env.example .env
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env
```

4. **Run with Docker Compose**
```bash
docker compose up -d
```

5. **Access the application**
- Frontend: http://localhost
- Backend API: http://localhost/api
- Health Check: http://localhost/health

### Development Mode (without Docker)

**Terminal 1 - Database:**
```bash
docker run -d \
  --name mysql-dev \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=userdb \
  -p 3306:3306 \
  mysql:8.0
```

**Terminal 2 - Backend:**
```bash
cd backend
npm install
npx prisma generate
npx prisma migrate deploy
npm run dev
```

**Terminal 3 - Frontend:**
```bash
cd frontend
npm install
npm run dev
```

Access at http://localhost:3000

## 🐳 Docker Hub Images

The application images are publicly available on Docker Hub:

- **Backend:** `aarchtou/youraws-backend:latest`
- **Frontend:** `aarchtou/youraws-frontend:latest`

Pull images:
```bash
docker pull aarchtou/youraws-backend:latest
docker pull aarchtou/youraws-frontend:latest
```

## ☁️ VPS Deployment (AWS EC2)

### Step 1: Create EC2 Instance

1. **Launch EC2 Instance:**
   - AMI: Ubuntu 22.04 LTS
   - Instance Type: t2.micro (or t2.small for better performance)
   - Storage: 20GB minimum

2. **Create/Download Key Pair:**
   ```bash
   chmod 400 your-key.pem
   ```

### Step 2: Configure Security Group

**Inbound Rules:**
- Port 80 (HTTP): `0.0.0.0/0` ← Application access
- Port 22 (SSH): `YOUR_IP/32` ← Restricted SSH access only!

**Outbound Rules:**
- All traffic: `0.0.0.0/0`

### Step 3: Connect and Setup VPS

```bash
# Connect to your instance
ssh -i your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP

# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker compose
sudo chmod +x /usr/local/bin/docker compose

# Verify installations
docker --version
docker compose --version

# Log out and back in for group changes
exit
```

### Step 4: Deploy Application

```bash
# Reconnect
ssh -i your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP

# Clone repository
git clone <your-repo-url>
cd UrawsAssessment

# Make deploy script executable
chmod +x deploy.sh

# Deploy
./deploy.sh
```

### Step 5: Verify Deployment

```bash
# Check running containers
docker compose ps

# View logs
docker compose logs -f

# Check nginx is serving on port 80
curl http://localhost

# From your local machine
curl http://YOUR_EC2_PUBLIC_IP
```

### Step 6: Configure Firewall (UFW)

```bash
# Enable UFW
sudo ufw allow 22/tcp    # SSH (will be restricted below)
sudo ufw allow 80/tcp    # HTTP
sudo ufw enable

# Restrict SSH to your IP only
sudo ufw delete allow 22/tcp
sudo ufw allow from YOUR_IP to any port 22

# Verify rules
sudo ufw status
```

## 🔧 Troubleshooting

### Container Issues

**Containers not starting:**
```bash
# Check logs
docker compose logs

# Restart specific service
docker compose restart backend

# Rebuild and restart
docker compose down
docker compose up -d --build
```

**Database connection errors:**
```bash
# Check MySQL is healthy
docker compose ps

# View MySQL logs
docker compose logs mysql

# Restart MySQL with fresh data
docker compose down -v  # ⚠️ This deletes data!
docker compose up -d
```

### Network Issues

**Can't access on port 80:**
```bash
# Check nginx is running
docker compose ps nginx

# Check nginx logs
docker compose logs nginx

# Verify port 80 is exposed
docker ps | grep nginx

# Check firewall
sudo ufw status
```

**Backend API not responding:**
```bash
# Check backend health
curl http://localhost/health

# Check backend logs
docker compose logs backend

# Verify backend is running
docker compose ps backend
```

### Application Issues

**Frontend not loading:**
```bash
# Check frontend container
docker compose logs frontend

# Rebuild frontend
cd frontend
docker build -t aarchtou/youraws-frontend:latest .
cd ..
docker compose up -d frontend
```

**Database migrations not applied:**
```bash
# Run migrations manually
docker compose exec backend npx prisma migrate deploy

# View migration status
docker compose exec backend npx prisma migrate status
```

### Performance Issues

**Slow response times:**
```bash
# Check resource usage
docker stats

# Increase container resources in docker compose.yml
# Add under each service:
deploy:
  resources:
    limits:
      cpus: '1.0'
      memory: 512M
```

**Cache not working (frontend):**
- Check browser DevTools → Network tab
- Look for `304 Not Modified` responses
- TanStack Query cache configured in `frontend/src/main.jsx`

## 🔒 Security Considerations

- ✅ SSH restricted to specific IP
- ✅ Only port 80 exposed externally
- ✅ Database not exposed to internet
- ✅ Environment variables for secrets
- ✅ Helmet.js for security headers
- ✅ Input validation on all endpoints
- ⚠️ For production: Add HTTPS with Let's Encrypt

## 📊 Monitoring

**View logs:**
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f backend

# Last 100 lines
docker compose logs --tail=100
```

**Check resource usage:**
```bash
docker stats
```

**Database access:**
```bash
docker compose exec mysql mysql -u root -p
# Password: rootpassword
```

## 🎓 Implementation Details

### Caching Strategy (Bonus Requirement)

The frontend implements intelligent caching using TanStack Query:

- **Stale Time:** 5 minutes - data considered fresh
- **Cache Time:** 10 minutes - data retained in cache
- **Automatic Background Refetch:** Updates stale data
- **Optimistic Updates:** Instant UI updates

This significantly reduces server load and improves UX!

### Docker Network Architecture

All containers run on the same `app-network`:
- Frontend → Backend: Internal routing
- Backend → MySQL: Internal routing
- Nginx → Frontend/Backend: Internal routing
- **Only Nginx exposes port 80 externally**

### Database Persistence

MySQL data is stored in a named volume `mysql_data`:
- Survives container restarts
- Persists even if containers are removed
- Can be backed up with: `docker run --rm -v mysql_data:/data -v $(pwd):/backup ubuntu tar czf /backup/mysql_backup.tar.gz /data`

## 📝 Submission Checklist

- ✅ Live application URL: `http://YOUR_EC2_PUBLIC_IP`
- ✅ GitHub repository: `<your-repo-url>`
- ✅ Docker Hub images:
  - `aarchtou/youraws-backend:latest`
  - `aarchtou/youraws-frontend:latest`
- ✅ Complete documentation (this README)
- ✅ All requirements met:
  - Frontend SPA with 2 pages ✅
  - Backend CRUD API ✅
  - MySQL database ✅
  - Dockerized ✅
  - VPS deployment ✅
  - Only port 80 exposed ✅
  - SSH restricted ✅
  - Bonus: Caching implemented ✅

## 👨‍💻 Development Notes

This application was built as a technical assessment demonstrating:
- Full-stack development skills
- Docker containerization
- Cloud deployment
- Security best practices
- Modern frontend patterns (SPA, caching)
- RESTful API design
- Database design and migrations
- DevOps practices

## 📄 License

This project is for assessment purposes.

---

**Built with ❤️ for YourAWS Technical Assessment**
