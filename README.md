# 📝 Django Notes App – AWS Deployment with Terraform, Docker, Jenkins  

## 📌 Overview  
This project is a **Django Notes App** deployed on **AWS** using **Terraform, Docker, Nginx, RDS MySQL, and Jenkins CI/CD**.  

The goal was to build a fully automated DevOps pipeline where:  
- Infrastructure is provisioned with **Terraform** (EC2, RDS, Security Groups).  
- App is containerized with **Docker & Docker Compose**.  
- Reverse proxy handled by **Nginx**.  
- Database hosted on **AWS RDS (MySQL)**.  
- CI/CD pipeline built with **Jenkins** to automate deployments and push Docker images to **Docker Hub**.  

---

## ⚙️ Tech Stack  
- **Django** – Backend framework  
- **MySQL (RDS)** – Database  
- **Nginx** – Reverse Proxy  
- **Docker & Docker Compose** – Containerization  
- **AWS EC2** – Compute Instances  
- **Terraform** – Infrastructure as Code  
- **Jenkins** – CI/CD Automation  

---

## 🚀 Features  
- Notes CRUD operations.  
- Configured to use **AWS RDS MySQL**.  
- **Nginx reverse proxy** with health check logic (wait for Django to be ready).  
- Automated **Jenkins pipeline** with agent/master setup.  
- Docker images pushed to **Docker Hub**.  
- Automated installation of dependencies (Jenkins, Docker, MySQL client, Java) via **Terraform user_data**.  

---

## 🛠️ Infrastructure Setup (Terraform)  
1. **Created 2 EC2 Instances**  
   - **Master Instance** → Installed Jenkins automatically via `user_data`.  
   - **Agent Instance** → Installed Docker, Docker Compose, Java, and MySQL client via `user_data`.  

2. **RDS Instance**  
   - Created using Terraform.  
   - Used **default VPC** subnets for connectivity.  
   - Configured security groups so **only the EC2 app** could access the DB.  

3. **Security Groups**  
   - Allowed traffic on HTTP (80), SSH (22), Jenkins (8080), and MySQL (3306 for EC2 only).  

---

## 🐳 Application Setup (Docker + Nginx + Django)  
- Modified **Django `settings.py`** to connect with RDS MySQL.  
- Updated **Nginx `default.conf`** for reverse proxying requests to Django.  
- Wrote **Dockerfile** for Django app and **docker-compose.yml** for multi-container setup.  
- Handled startup dependency → ensured Nginx waits until Django app is ready.  

---

## 🔄 CI/CD Pipeline (Jenkins)  
- **Agent node** registered with Jenkins master.  
- Pipeline stages:  
  1. **Clone code** from GitHub.  
  2. **Build Docker image** for Django app.  
  3. **Push image** to Docker Hub.  
  4. **Deploy app** on EC2 agent using Docker Compose.  

---

## 📝 How to Run Locally  
```bash
# Clone the repo
git clone <your-repo-url>
cd django-notes-app

# Build & run with Docker Compose
docker compose up --build -d

# App available at
http://localhost:8000
