# Cloud-Native Todo Platform

A full-stack Todo application deployed on AWS, built to demonstrate practical skills in **Cloud Infrastructure, Docker, CI/CD, Continuous Deployment, Kubernetes, and Platform Engineering**.

The project combines a React frontend, FastAPI backend, and PostgreSQL database, with automated build and deployment workflows using GitHub Actions and AWS services.

## Architecture

```text
                    Developer
                        |
                        v
                   GitHub Repo
                        |
                        v
                 GitHub Actions
                        |
              +---------+---------+
              |                   |
              v                   v
         Build & Test        Docker Images
                                  |
                                  v
                             Amazon ECR
                                  |
                                  v
                         AWS Systems Manager
                                  |
                                  v
                              EC2 Instance
                                  |
                            Docker Compose
                                  |
                    +-------------+-------------+
                    |             |             |
                    v             v             v
                 Frontend      Backend       PostgreSQL
                 React         FastAPI        Database
                    |
                    v
                  Nginx
                    |
                    v
             Application Load Balancer
```

## Technology Stack

| Area | Technologies |
|---|---|
| Frontend | React, JavaScript |
| Backend | Python, FastAPI |
| Database | PostgreSQL |
| Containers | Docker, Docker Compose |
| Cloud | AWS |
| Compute | Amazon EC2 |
| Container Registry | Amazon ECR |
| Networking | Application Load Balancer, Nginx |
| CI/CD | GitHub Actions |
| AWS Authentication | GitHub Actions OIDC |
| Remote Deployment | AWS Systems Manager (SSM) |
| Infrastructure as Code | Terraform (in progress) |
| Version Control | Git, GitHub |

## Implemented Features

### 1. Full-Stack Application

- React-based frontend.
- FastAPI backend with REST API endpoints.
- PostgreSQL database integration.
- Containerized application services.
- Health endpoint for backend and database connectivity verification.

### 2. AWS Infrastructure and Deployment

- Application hosted on an Amazon EC2 instance.
- Application Load Balancer configured to route incoming traffic.
- Nginx serving the frontend and handling API requests.
- Amazon ECR storing backend and frontend Docker images.
- Docker Compose managing application containers.
- AWS Systems Manager used to access and manage the EC2 instance without relying on direct SSH access.

### 3. Continuous Integration (CI)

GitHub Actions automatically runs the CI workflow when code is pushed to the main branch or a pull request is created against main.

The pipeline includes:

- Frontend dependency installation and production build.
- Backend dependency installation and Python syntax validation.
- Docker image builds for frontend and backend.
- AWS authentication using GitHub OIDC.
- Publishing Docker images to Amazon ECR.

### 4. Continuous Deployment (CD)

Continuous deployment is implemented through GitHub Actions and AWS Systems Manager.

After a successful push to the main branch:

1. GitHub Actions builds the frontend and backend Docker images.
2. Images are tagged using the Git commit SHA.
3. Images are pushed to their respective Amazon ECR repositories.
4. GitHub Actions triggers an AWS Systems Manager command on the EC2 instance.
5. The EC2 deployment script pulls the specified image versions.
6. Docker Compose updates the application containers.
7. The deployment script checks the backend health status.
8. The GitHub Actions workflow waits for the remote deployment command and reports its result.

This provides a continuous deployment workflow from a GitHub commit to the running application on AWS.

### 5. Secure GitHub-to-AWS Authentication

GitHub Actions authenticates with AWS using OpenID Connect (OIDC).

- No long-lived AWS access keys are stored in GitHub Secrets.
- IAM role-based access is configured for GitHub Actions.
- ECR permissions are scoped to the application's repositories.
- SSM permissions allow the workflow to trigger and monitor deployment commands.

### 6. Automatic Deployment Rollback

An automatic rollback mechanism has been implemented in the EC2 deployment script.

Before deploying a new version, the script records the currently running backend and frontend image references.

If deployment fails:

1. The failure is detected by the deployment script.
2. The previously running image references are used.
3. Docker Compose attempts to restore the previous application containers.
4. The deployment failure is reported to GitHub Actions.

**Rollback testing:** The rollback mechanism was tested by deliberately using an invalid image tag. The image pull failed, the rollback was triggered, and the previously running application remained available.

Further testing of failures occurring after new containers start is still planned.

## CI/CD Pipeline

| Stage | Description | Status |
|---|---|---|
| Source | Push code to GitHub main branch | Implemented |
| CI | Build frontend and validate backend | Implemented |
| Docker | Build frontend and backend images | Implemented |
| Authentication | GitHub OIDC authentication with AWS | Implemented |
| Registry | Push SHA-tagged images to ECR | Implemented |
| Deployment | Trigger EC2 deployment through SSM | Implemented |
| Health Check | Verify backend health after deployment | Implemented |
| Rollback | Restore previously running image versions on failure | Implemented and initial failure path tested |

## AWS Resources

The project currently uses the following AWS resources:

- Amazon EC2
- Application Load Balancer
- Elastic Container Registry (ECR)
- AWS Systems Manager
- IAM roles and policies
- GitHub Actions OIDC identity provider

**AWS Region:** `ap-northeast-1` (Tokyo)

## Repository Structure

```text
cloud-native-todo-platform/
│
├── frontend/
│   └── React application
│
├── backend/
│   └── FastAPI application
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── docker-compose.yml
├── docker-compose.prod.yml
├── Dockerfile
└── README.md
```

The exact deployment configuration is maintained on the EC2 instance at `/opt/todo-app`, including the active Compose configuration and deployment script.

## Current Development Status

| Area | Status |
|---|---|
| Full-stack application | Completed |
| Docker containerization | Completed |
| AWS EC2 deployment | Completed |
| Application Load Balancer | Completed |
| ECR image management | Completed |
| GitHub Actions CI | Completed |
| GitHub OIDC authentication | Completed |
| Automated continuous deployment | Completed |
| Backend deployment health check | Completed |
| Automatic rollback mechanism | Implemented; initial failure path tested |
| Terraform infrastructure automation | In progress |

## Roadmap

- [ ] Complete AWS infrastructure provisioning using Terraform.
- [ ] Manage EC2 deployment configuration and scripts directly from the GitHub repository.
- [ ] Add frontend and application-level smoke tests after deployment.
- [ ] Test rollback when a newly started application version fails its health check.
- [ ] Improve deployment observability and logging.
- [ ] Explore Kubernetes deployment using Amazon EKS.
- [ ] Implement monitoring and alerting.

## Project Objective

The goal of this project is to develop practical Platform Engineering skills by building and operating a cloud-native application.

It focuses on understanding the complete application lifecycle—from source code and containerization to cloud infrastructure, CI/CD, deployment automation, health validation, and rollback.