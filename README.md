# Cloud-Native Todo Platform

A full-stack Todo application built to demonstrate modern cloud infrastructure, containerization, Infrastructure as Code (IaC), and CI/CD automation using AWS, Docker, Terraform, and GitHub Actions.

The project focuses on building and operating a cloud-native application with an automated build and container image publishing pipeline.

## Architecture

```text
                   Developer
                       |
                       v
                GitHub Repository
                       |
                       v
                GitHub Actions CI
                       |
             +---------+---------+
             |                   |
        Frontend Build      Backend Validation
             |                   |
             +---------+---------+
                       |
                  Docker Build
                       |
                       v
               GitHub Actions OIDC
                       |
                 AWS IAM Role
                       |
                       v
                 Amazon ECR
                 /         \
                /           \
       Backend Image    Frontend Image
                \           /
                 \         /
                  Future Deployment
                       |
                       v
                  AWS EC2
                       |
                 Docker Compose
                       |
                     Nginx
                       |
                Application Users
```

## Technology Stack

| Category | Technologies |
|---|---|
| Frontend | React, JavaScript, HTML, CSS |
| Backend | Python, FastAPI |
| Database | PostgreSQL |
| Containers | Docker, Docker Compose |
| Cloud | AWS EC2, Application Load Balancer, Amazon ECR |
| Infrastructure as Code | Terraform |
| CI/CD | GitHub Actions |
| Authentication | AWS IAM, GitHub OIDC |
| Web Server / Reverse Proxy | Nginx |
| Version Control | Git, GitHub |

## Project Structure

```text
cloud-native-todo-platform/
│
├── frontend/
│   ├── src/
│   ├── public/
│   ├── package.json
│   ├── package-lock.json
│   └── Dockerfile
│
├── backend/
│   ├── app/
│   ├── requirements.txt
│   └── Dockerfile
│
├── terraform/
│   └── # Infrastructure configuration
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── docker-compose.yml
├── README.md
└── .gitignore
```

## Application Features

- React-based frontend.
- FastAPI backend.
- PostgreSQL database integration.
- Containerized frontend and backend services.
- Docker Compose-based application deployment.
- AWS-hosted application environment.

## Infrastructure and Deployment

The application has been deployed on AWS using the following components:

- **Amazon EC2:** Hosts the application containers.
- **Application Load Balancer:** Provides an entry point for application traffic.
- **Docker Compose:** Manages application containers.
- **Nginx:** Handles reverse proxy and application traffic routing.
- **Amazon ECR:** Stores backend and frontend Docker images.

Terraform is used for Infrastructure as Code and managing cloud infrastructure.

## CI/CD Pipeline

GitHub Actions automates application validation, Docker image creation, and image publishing to Amazon ECR.

### Pipeline Workflow

1. Code is pushed to the `main` branch or a pull request is created.
2. GitHub Actions checks out the source code.
3. Frontend dependencies are installed using `npm ci`.
4. Frontend production build is executed.
5. Backend dependencies are installed.
6. Backend Python syntax is validated.
7. Backend and frontend Docker images are built.
8. For pushes to `main`, GitHub Actions authenticates with AWS using OIDC.
9. Docker images are tagged with the Git commit SHA.
10. Images are pushed to Amazon ECR.

### GitHub Actions Workflow

Workflow file:

```text
.github/workflows/ci.yml
```

### AWS Authentication Using OIDC

The pipeline uses OpenID Connect (OIDC) to authenticate GitHub Actions with AWS without storing long-lived AWS access keys in GitHub Secrets.

Authentication flow:

```text
GitHub Actions
      |
      v
GitHub OIDC Identity Token
      |
      v
AWS IAM OIDC Provider
      |
      v
IAM Role Trust Policy
      |
      v
Temporary AWS Credentials
      |
      v
Amazon ECR
```

The IAM role is configured with permissions to push images to the two application repositories.

### Amazon ECR Repositories

| Repository | Purpose |
|---|---|
| `ankit-todo-backend` | Backend Docker image |
| `ankit-todo-frontend` | Frontend Docker image |

Images are tagged using the GitHub commit SHA to maintain traceability between source code changes and container images.

## Local Development

### Prerequisites

- Git
- Node.js
- Python
- Docker
- Docker Compose

### Clone the Repository

```bash
git clone https://github.com/ankitguptasato/cloud-native-todo-platform.git

cd cloud-native-todo-platform
```

### Start the Application

```bash
docker compose up --build -d
```

### Check Running Containers

```bash
docker compose ps
```

### View Application Logs

```bash
docker compose logs -f
```

### Stop the Application

```bash
docker compose down
```

## Current Implementation Status

| Component | Status |
|---|---|
| React frontend | Implemented |
| FastAPI backend | Implemented |
| PostgreSQL integration | Implemented |
| Docker containerization | Implemented |
| Docker Compose | Implemented |
| AWS EC2 deployment | Implemented |
| Application Load Balancer | Implemented |
| Nginx reverse proxy | Implemented |
| Terraform infrastructure | In progress |
| GitHub Actions CI pipeline | Implemented |
| GitHub OIDC authentication | Implemented |
| AWS ECR image publishing | Implemented |
| Automated EC2 deployment from ECR | Planned |

## Roadmap

- [x] Build full-stack Todo application.
- [x] Containerize frontend and backend.
- [x] Deploy application on AWS EC2.
- [x] Configure Application Load Balancer and Nginx.
- [x] Build GitHub Actions CI workflow.
- [x] Configure GitHub OIDC authentication with AWS.
- [x] Automate Docker image publishing to Amazon ECR.
- [ ] Complete Terraform-based infrastructure management.
- [ ] Automate EC2 deployment from ECR.
- [ ] Implement deployment health checks and rollback.
- [ ] Introduce automated backend tests.
- [ ] Explore Kubernetes-based deployment and orchestration.
- [ ] Add monitoring, logging, and observability.

## Project Goal

This project is a practical learning initiative focused on Platform Engineering, Cloud Infrastructure, and DevOps.

The objective is to understand and implement the complete application lifecycle, from source code and infrastructure provisioning to containerization, CI/CD automation, deployment, and operational monitoring.
