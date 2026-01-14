# User Management System - YourAWS Technical Assessment

A full-stack user management application with React frontend, Node.js/Express backend, MySQL database, fully containerized with Docker and deployable to any VPS. Features automated CI/CD pipeline with blue-green deployment to AWS EC2.

## 🚀 Quick Start

### For Automated Deployment to AWS EC2:

1. **Fork/Clone this repository**
2. **Configure GitHub Secrets** (see Automated Deployment section below)
3. **Set up your EC2 instance** with Docker and SSM Agent
4. **Trigger deployment:**
   ```bash
   git checkout release
   echo "Deploy $(date)" > deploy-trigger.txt
   git add deploy-trigger.txt
   git commit -m "chore: trigger deployment"
   git push origin release
   ```
5. **Watch deployment** in GitHub Actions tab
6. **Access your app** at `http://YOUR_EC2_PUBLIC_IP`

### For Local Development:

```bash
# Clone repository
git clone <your-repo-url>
cd UrawsAssessment

# Run with Docker Compose
docker-compose up -d

# Access application
open http://localhost
```

---

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
- ✅ Multi-container setup with docker-compose
- ✅ **Only port 80 exposed** (requirement met!)
- ✅ All containers on same network
- ✅ Health checks for reliability
- ✅ Images pushed to Docker Hub
- ✅ **Automated CI/CD Pipeline with Blue-Green Deployment**
- ✅ **Auto-deploy from release branch to AWS EC2**
- ✅ **Zero-downtime deployments with rollback capability**

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
docker-compose up -d
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

## 📁 Project Structure

```
UrawsAssessment/
├── .github/
│   └── workflows/
│       └── release-deploy.yml        # CI/CD pipeline configuration
├── backend/
│   ├── prisma/
│   │   └── schema.prisma             # Database schema
│   ├── src/
│   │   ├── routes/                   # API routes
│   │   ├── controllers/              # Business logic
│   │   └── middleware/               # Error handling, validation
│   ├── Dockerfile                    # Backend container image
│   └── package.json
├── frontend/
│   ├── src/
│   │   ├── components/               # React components
│   │   ├── pages/                    # Page components
│   │   ├── services/                 # API client
│   │   └── App.jsx
│   ├── Dockerfile                    # Frontend container image
│   └── package.json
├── nginx/
│   └── nginx.conf                    # Reverse proxy configuration
├── deploy/
│   ├── deploy.sh                     # Deployment script
│   ├── pre_deploy.sh                 # Pre-deployment checks
│   └── post_deploy.sh                # Post-deployment verification
├── docker-compose.yml                # Multi-container orchestration
├── deploy-trigger.txt                # Triggers CI/CD when updated
└── README.md
```

### Key Files for CI/CD

- **`.github/workflows/release-deploy.yml`** - GitHub Actions workflow that handles automated deployment
- **`deploy-trigger.txt`** - Update this file on `release` branch to trigger deployment
- **`docker-compose.yml`** - Downloaded from main branch during deployment
- **`nginx/nginx.conf`** - Nginx configuration for reverse proxy

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

### Deployment Options

You have two deployment options:

1. **🚀 Automated Deployment (Recommended)** - Uses GitHub Actions to auto-deploy from the `release` branch
2. **🔧 Manual Deployment** - Traditional SSH and Docker Compose approach

---

## 🚀 Option 1: Automated Deployment Pipeline

This project includes a complete CI/CD pipeline that automatically deploys to AWS EC2 when you push to the `release` branch.

### Pipeline Features

- ✅ **Blue-Green Deployment** - Zero downtime deployments
- ✅ **Automatic Image Building** - Builds Docker images from `main` branch
- ✅ **AWS SSM Integration** - No SSH keys needed
- ✅ **Rollback Capability** - Previous releases preserved
- ✅ **Health Checks** - Automated verification
- ✅ **Release Tracking** - Timestamped releases

### How It Works

```
┌─────────────┐     ┌──────────────┐     ┌──────────────┐     ┌─────────────┐
│   main      │────▶│ GitHub       │────▶│ Build        │────▶│ Docker Hub  │
│   branch    │     │ Actions      │     │ Images       │     │             │
└─────────────┘     └──────────────┘     └──────────────┘     └─────────────┘
                                                                       │
┌─────────────┐     ┌──────────────┐     ┌──────────────┐            │
│  release    │────▶│ Trigger      │────▶│ Deploy to    │◀───────────┘
│  branch     │     │ Deployment   │     │ AWS EC2      │
└─────────────┘     └──────────────┘     └──────────────┘
                                                │
                                          ┌─────▼─────────┐
                                          │ Blue-Green    │
                                          │ Switch        │
                                          └───────────────┘
```

### Prerequisites

1. **AWS Account Setup:**
   - EC2 instance running Ubuntu 22.04
   - AWS SSM Agent installed and running
   - IAM role with SSM permissions attached to EC2
   - Docker and Docker Compose installed on EC2

2. **GitHub Secrets Configuration:**
   
   Go to your GitHub repository → Settings → Secrets and variables → Actions → New repository secret:

   | Secret Name              | Description                          | Example                                    |
   |--------------------------|--------------------------------------|--------------------------------------------|
   | `AWS_ACCESS_KEY_ID`      | AWS IAM Access Key                   | `AKIAIOSFODNN7EXAMPLE`                     |
   | `AWS_SECRET_ACCESS_KEY`  | AWS IAM Secret Key                   | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
   | `EC2_INSTANCE_ID`        | Your EC2 Instance ID                 | `i-0123456789abcdef0`                      |
   | `DOCKERHUB_TOKEN`        | Docker Hub Access Token (optional)   | `dckr_pat_...`                             |

### Step-by-Step Deployment Setup

#### 1. Set Up AWS EC2 Instance

```bash
# Launch EC2 instance (Ubuntu 22.04 LTS, t2.micro or t2.small)
# Security Group: Allow port 80 (HTTP) from 0.0.0.0/0
#                 Allow port 22 (SSH) from your IP

# Connect to instance
ssh -i your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP

# Install Docker
sudo apt update
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify SSM agent is running
sudo systemctl status amazon-ssm-agent
```

#### 2. Create IAM Role for EC2

1. Go to AWS IAM Console → Roles → Create role
2. Select "AWS service" → "EC2"
3. Attach policy: `AmazonSSMManagedInstanceCore`
4. Name: `EC2-SSM-Role`
5. Attach this role to your EC2 instance

#### 3. Create IAM User for GitHub Actions

1. Go to AWS IAM Console → Users → Create user
2. User name: `github-actions-deploy`
3. Attach policies:
   - `AmazonSSMFullAccess` (or create custom policy with limited SSM permissions)
   - `AmazonEC2ReadOnlyAccess`
4. Create access key → Save credentials

#### 4. Configure GitHub Secrets

Add the following secrets to your repository:

```bash
# Go to: https://github.com/YOUR_USERNAME/YOUR_REPO/settings/secrets/actions

AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
EC2_INSTANCE_ID=i-0123456789abcdef0
DOCKERHUB_TOKEN=dckr_pat_xxxxx (optional)
```

#### 5. Trigger Deployment

The deployment automatically triggers when you:

1. **Update the trigger file on release branch:**

```bash
# On your local machine
git checkout release
echo "Deploy $(date)" > deploy-trigger.txt
git add deploy-trigger.txt
git commit -m "chore: trigger deployment"
git push origin release
```

2. **Watch the deployment:**
   - Go to GitHub → Actions tab
   - Click on the running workflow
   - Monitor deployment progress

3. **Verify deployment:**

```bash
# Check your application
curl http://YOUR_EC2_PUBLIC_IP/health
curl http://YOUR_EC2_PUBLIC_IP

# SSH to EC2 and check releases
ssh -i your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP
ls -la /home/ubuntu/releases/
docker-compose ps
```

### Deployment Workflow Details

The pipeline performs these steps automatically:

1. **Fetch Latest Code** - Gets the latest commit SHA from `main` branch
2. **Build Images** - Builds Docker images with the commit SHA as tag
3. **Push to Docker Hub** - Pushes images to Docker Hub
4. **Download Configs** - Downloads docker-compose.yml and configs from main
5. **Create Release Directory** - Creates timestamped release directory
6. **Update Image Tags** - Updates docker-compose.yml with new image tags
7. **Pull Images** - Pulls new images to EC2
8. **Test Release** - Validates the new release
9. **Blue-Green Switch** - Switches to new release with zero downtime
10. **Health Check** - Verifies application is healthy
11. **Keep Previous Release** - Preserves previous release for rollback

### Manual Rollback

If something goes wrong, you can manually rollback:

```bash
# SSH to your EC2 instance
ssh -i your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP

# List available releases
ls -la /home/ubuntu/releases/

# Rollback to previous release
cd /home/ubuntu/releases/myapp-release-TIMESTAMP
docker-compose up -d

# Or use your deploy.sh script
./deploy/deploy.sh /home/ubuntu/releases/myapp-release-TIMESTAMP
```

### Monitoring Deployments

**View deployment logs in GitHub Actions:**
1. Go to GitHub → Actions tab
2. Click on the workflow run
3. Expand each step to see logs

**View deployment on EC2:**
```bash
# SSH to EC2
ssh -i your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP

# Check active containers
docker-compose ps

# View logs
docker-compose logs -f

# Check releases
ls -lat /home/ubuntu/releases/
```

### Deployment Best Practices

1. **Always test on main branch first** - The pipeline pulls code from main
2. **Update deploy-trigger.txt to trigger deployment** - Only changes to this file trigger deployment
3. **Monitor the first deployment** - SSH to EC2 and watch the process
4. **Keep at least 3 releases** - For easy rollback
5. **Set up CloudWatch** - For monitoring and alerts

---

## 🔧 Option 2: Manual Deployment

If you prefer traditional manual deployment:

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
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installations
docker --version
docker-compose --version

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
docker-compose ps

# View logs
docker-compose logs -f

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

### CI/CD Pipeline Issues

**Workflow not triggering:**
```bash
# Make sure you're on the release branch
git checkout release

# Verify the file is tracked
git status

# Check if workflow file exists
ls -la .github/workflows/release-deploy.yml
```

**AWS Credentials Error:**
- Verify secrets are set in GitHub: Settings → Secrets → Actions
- Check IAM user has correct permissions: `AmazonSSMFullAccess`
- Verify AWS region matches in workflow file

**SSM Connection Failed:**
```bash
# SSH to EC2 and check SSM agent
sudo systemctl status amazon-ssm-agent

# Restart SSM agent
sudo systemctl restart amazon-ssm-agent

# Verify IAM role is attached to EC2 instance
aws ec2 describe-instances --instance-ids YOUR_INSTANCE_ID \
  --query 'Reservations[0].Instances[0].IamInstanceProfile'
```

**Docker Image Pull Failed:**
- Check Docker Hub credentials (if using private repos)
- Verify image tags exist: `docker pull aarchtou/youraws-backend:COMMIT_SHA`
- Check EC2 has internet access

**Deployment Hangs:**
```bash
# SSH to EC2 and check what's running
ps aux | grep docker
docker ps -a

# Check SSM command status in AWS Console
# EC2 → Systems Manager → Run Command → Command history
```

### Container Issues

**Containers not starting:**
```bash
# Check logs
docker-compose logs

# Restart specific service
docker-compose restart backend

# Rebuild and restart
docker-compose down
docker-compose up -d --build
```

**Database connection errors:**
```bash
# Check MySQL is healthy
docker-compose ps

# View MySQL logs
docker-compose logs mysql

# Restart MySQL with fresh data
docker-compose down -v  # ⚠️ This deletes data!
docker-compose up -d
```

### Network Issues

**Can't access on port 80:**
```bash
# Check nginx is running
docker-compose ps nginx

# Check nginx logs
docker-compose logs nginx

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
docker-compose logs backend

# Verify backend is running
docker-compose ps backend
```

### Application Issues

**Frontend not loading:**
```bash
# Check frontend container
docker-compose logs frontend

# Rebuild frontend
cd frontend
docker build -t aarchtou/youraws-frontend:latest .
cd ..
docker-compose up -d frontend
```

**Database migrations not applied:**
```bash
# Run migrations manually
docker-compose exec backend npx prisma migrate deploy

# View migration status
docker-compose exec backend npx prisma migrate status
```

### Performance Issues

**Slow response times:**
```bash
# Check resource usage
docker stats

# Increase container resources in docker-compose.yml
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
docker-compose logs -f

# Specific service
docker-compose logs -f backend

# Last 100 lines
docker-compose logs --tail=100
```

**Check resource usage:**
```bash
docker stats
```

**Database access:**
```bash
docker-compose exec mysql mysql -u root -p
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
- ✅ GitHub repository with CI/CD pipeline
- ✅ Docker Hub images:
  - `aarchtou/youraws-backend:latest`
  - `aarchtou/youraws-frontend:latest`
- ✅ Complete documentation (this README)
- ✅ Automated deployment pipeline:
  - Blue-Green deployment strategy ✅
  - GitHub Actions integration ✅
  - AWS SSM deployment ✅
  - Rollback capability ✅
- ✅ All requirements met:
  - Frontend SPA with 2 pages ✅
  - Backend CRUD API ✅
  - MySQL database ✅
  - Dockerized ✅
  - VPS deployment ✅
  - Only port 80 exposed ✅
  - SSH restricted ✅
  - Bonus: Caching implemented ✅
  - Bonus: CI/CD Pipeline ✅

## 🔄 CI/CD Pipeline Summary

### Pipeline Trigger
```bash
# Update and push to release branch
git checkout release
echo "Deploy $(date)" > deploy-trigger.txt
git add deploy-trigger.txt
git commit -m "chore: trigger deployment"
git push origin release
```

### What Happens Automatically

1. **GitHub Actions detects push to `release` branch**
2. **Fetches latest commit SHA from `main` branch**
3. **Builds Docker images** (backend and frontend)
4. **Pushes images to Docker Hub** with commit SHA as tag
5. **Connects to EC2 via AWS SSM** (no SSH keys needed!)
6. **Downloads latest configs** from main branch
7. **Creates timestamped release directory** on EC2
8. **Updates docker-compose.yml** with new image tags
9. **Pulls new Docker images** to EC2
10. **Performs health checks** on new release
11. **Switches to new release** (blue-green deployment)
12. **Verifies deployment** with automated tests
13. **Keeps previous release** for easy rollback

### Deployment Flow Diagram

```
Developer                 GitHub                   AWS EC2
    │                        │                        │
    │  git push release      │                        │
    ├───────────────────────▶│                        │
    │                        │                        │
    │                        │  Trigger Workflow      │
    │                        ├────────┐               │
    │                        │        │               │
    │                        │  Build Images          │
    │                        │        │               │
    │                        │◀───────┘               │
    │                        │                        │
    │                        │  Push to Docker Hub    │
    │                        ├───────────────────┐    │
    │                        │                   │    │
    │                        │◀──────────────────┘    │
    │                        │                        │
    │                        │  Deploy via SSM        │
    │                        ├───────────────────────▶│
    │                        │                        │
    │                        │                        │  Pull Images
    │                        │                        ├──────┐
    │                        │                        │      │
    │                        │                        │◀─────┘
    │                        │                        │
    │                        │                        │  Blue-Green
    │                        │                        │  Switch
    │                        │                        ├──────┐
    │                        │                        │      │
    │                        │                        │◀─────┘
    │                        │                        │
    │                        │  ✅ Deployment Success  │
    │                        │◀───────────────────────┤
    │                        │                        │
    │  View live app         │                        │
    ├────────────────────────┼───────────────────────▶│
    │◀───────────────────────┼────────────────────────┤
    │                        │                        │
```

### Rollback Procedure

If you need to rollback to a previous version:

```bash
# SSH to EC2
ssh -i your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP

# List all releases (sorted by date)
ls -lat /home/ubuntu/releases/

# Rollback to specific release
cd /home/ubuntu/releases/myapp-release-20260114120000
docker-compose down
docker-compose up -d

# Verify rollback
docker-compose ps
curl http://localhost/health
```

### Monitoring & Debugging

**GitHub Actions Logs:**
- Go to repository → Actions tab
- Click on workflow run
- View detailed logs for each step

**EC2 Application Logs:**
```bash
ssh -i your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP

# View all container logs
docker-compose logs -f

# View specific service
docker-compose logs -f backend
docker-compose logs -f frontend

# Check container status
docker-compose ps

# View releases
ls -la /home/ubuntu/releases/
```

**SSM Command Logs:**
```bash
# On EC2
ls -la /var/log/amazon/ssm/

# View recent commands
sudo cat /var/log/amazon/ssm/amazon-ssm-agent.log
```

## 👨‍💻 Development Notes

This application was built as a technical assessment demonstrating:
- Full-stack development skills
- Docker containerization
- Cloud deployment (AWS EC2)
- **CI/CD pipeline with GitHub Actions**
- **Blue-Green deployment strategy**
- **Infrastructure as Code**
- **AWS Systems Manager integration**
- Security best practices
- Modern frontend patterns (SPA, caching)
- RESTful API design
- Database design and migrations
- DevOps practices

### Technology Choices

**GitHub Actions for CI/CD:**
- Free for public repositories
- Native GitHub integration
- Easy secret management
- Powerful workflow automation

**AWS SSM for Deployment:**
- No SSH keys to manage
- Better security
- Audit trail of all commands
- Works with private subnets

**Blue-Green Deployment:**
- Zero downtime deployments
- Instant rollback capability
- Safe production deployments
- A/B testing support

**Docker Hub:**
- Public image registry
- Version tagging with commit SHAs
- Easy image distribution
- CI/CD friendly

## 📄 License

This project is for assessment purposes.

---

**Built with ❤️ for YourAWS Technical Assessment**
