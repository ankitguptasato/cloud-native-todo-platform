# Cloud-Native Todo Platform

A full-stack application built and deployed on AWS to demonstrate practical **Cloud Engineering, DevOps, Kubernetes, CI/CD, Infrastructure as Code, and Platform Engineering** skills.

The project started with a Docker Compose deployment on Amazon EC2 and has evolved into a Kubernetes-based architecture using Amazon EKS.

It combines a React frontend, FastAPI backend, and PostgreSQL database with AWS infrastructure, container orchestration, persistent storage, automated workflows, and public application access through an AWS Application Load Balancer.

## Architecture

### Current Architecture — Amazon EKS

```text
                         Developer
                             |
                             v
                         GitHub Repo
                             |
                             v
                       GitHub Actions
                             |
                             v
                      Docker Images
                             |
                             v
                         Amazon ECR
                             |
                             v
                     Amazon EKS Cluster
                       platform-lab
                             |
                 +-----------+-----------+
                 |                       |
                 v                       v
            Worker Node 1           Worker Node 2
                 |                       |
                 |                  Frontend Pod
                 |                    (React)
                 |
          +------+------+
          |             |
          v             v
      Backend Pod   PostgreSQL Pod
       (FastAPI)     (Database)
          |             |
          +------+------+
                 |
          Internal Services
                 |
                 v
          EKS Persistent Storage
             (EBS / gp3)


Internet
   |
   v
AWS Application Load Balancer
   |
   v
Kubernetes Ingress (ALB)
   |
   v
Frontend Service
   |
   v
Frontend Pod (Nginx)
   |
   | /api/
   v
Backend Service
   |
   v
Backend Pod (FastAPI)
   |
   v
PostgreSQL Service
   |
   v
PostgreSQL Pod
```

**Application traffic flow:**

```text
Browser
   |
   v
AWS Application Load Balancer (HTTP :80)
   |
   v
Kubernetes Ingress
   |
   v
Frontend Service (ClusterIP :80)
   |
   v
Frontend Pod (Container :8080)
   |
   v
Nginx Reverse Proxy (/api/)
   |
   v
Backend Service (ClusterIP :8000)
   |
   v
Backend Pod (FastAPI)
   |
   v
PostgreSQL Service (ClusterIP :5432)
   |
   v
PostgreSQL Pod
```

The frontend is publicly accessible through the ALB. Backend and PostgreSQL services remain internal to the Kubernetes cluster.

## Technology Stack

| Area | Technologies |
|---|---|
| Frontend | React, JavaScript |
| Backend | Python, FastAPI |
| Database | PostgreSQL 16 |
| Containers | Docker, Docker Compose |
| Container Orchestration | Kubernetes, Amazon EKS |
| Cloud Provider | AWS |
| Compute | Amazon EC2, EKS Managed Node Groups |
| Container Registry | Amazon ECR |
| Networking | VPC, Subnets, Security Groups, AWS ALB |
| Kubernetes Networking | Services, Ingress, AWS Load Balancer Controller |
| Persistent Storage | Amazon EBS, EBS CSI Driver, gp3 |
| Infrastructure as Code | Terraform |
| Package Management | Helm |
| CI/CD | GitHub Actions |
| AWS Authentication | IAM, GitHub OIDC, IRSA |
| Deployment Management | AWS Systems Manager (SSM) |
| Application Proxy | Nginx |
| Version Control | Git, GitHub |

## Implemented Features

### 1. Full-Stack Application

- React-based frontend application.
- FastAPI backend with REST API endpoints.
- PostgreSQL database integration.
- Containerized frontend and backend services.
- Backend health endpoint for application health verification.
- Nginx reverse proxy for routing frontend API requests to the backend.

### 2. Docker and Containerization

- Created Docker images for frontend and backend.
- Used Docker Compose to manage the initial multi-container application.
- Configured application networking between frontend, backend, and PostgreSQL.
- Implemented PostgreSQL health checks.
- Configured persistent database storage using Docker volumes.
- Published application images to Amazon ECR.
- Used Git commit SHA-based image tagging for version tracking.

### 3. AWS Infrastructure and Terraform

Infrastructure provisioning and management using Terraform.

Implemented infrastructure includes:

- AWS VPC with public and private subnets across multiple Availability Zones.
- Internet Gateway and route tables.
- Security Groups.
- Amazon EKS cluster.
- EKS managed worker node group.
- IAM roles and policies for EKS components.
- EKS OIDC identity provider integration.
- Amazon ECR repositories.
- Amazon EBS CSI add-on integration.
- AWS Load Balancer Controller IAM configuration.
- Kubernetes subnet discovery tags.

AWS Region: `ap-northeast-1` (Tokyo).

### 4. Amazon EKS and Kubernetes

Deployed the full-stack application on Amazon EKS.

Implemented Kubernetes resources:

- Deployments for frontend, backend, and PostgreSQL.
- ClusterIP Services for internal application communication.
- PersistentVolumeClaim for PostgreSQL storage.
- Amazon EBS-backed gp3 persistent storage.
- EBS CSI Driver for dynamic volume provisioning.
- Kubernetes Ingress for external application access.
- AWS Load Balancer Controller integration.

**Current cluster configuration:**

| Component | Configuration |
|---|---|
| Cluster | platform-lab |
| Kubernetes Version | 1.37 |
| Region | ap-northeast-1 |
| Worker Nodes | 2 |
| Instance Type | t3.small |
| Capacity Type | On-Demand |
| Node Group | platform-lab-workers |
| Storage | Amazon EBS gp3 |

The worker node group was scaled from one to two nodes after identifying the Kubernetes Pod capacity limitation on the original single-node configuration.

This provided additional scheduling capacity and allowed the frontend Pod to run successfully on the second worker node.

### 5. Kubernetes Networking and AWS Load Balancer Controller

Implemented external access to the application using the AWS Load Balancer Controller.

- Installed AWS Load Balancer Controller using Helm.
- Configured IAM permissions using an IAM policy and role.
- Integrated IAM Roles for Service Accounts (IRSA).
- Configured the EKS OIDC identity provider.
- Registered the ALB IngressClass.
- Configured public subnet tags for Kubernetes load balancer discovery.
- Created an internet-facing Application Load Balancer through Kubernetes Ingress.
- Configured ALB target type as IP to route traffic directly to Pod IPs.
- Configured HTTP listener on port 80.
- Configured frontend health check path.
- Exposed only the frontend service publicly.
- Kept backend and PostgreSQL services internal.

**Application endpoint:**

```text
http://k8s-default-todoingr-e37448c463-778204260.ap-northeast-1.elb.amazonaws.com
```

The ALB successfully provisions and routes traffic to the frontend Pod.

### 6. Database Deployment and Persistent Storage

PostgreSQL is deployed inside Kubernetes with persistent storage.

- PostgreSQL deployed using a Kubernetes Deployment.
- Internal ClusterIP Service configured on port 5432.
- PersistentVolumeClaim configured with 5Gi storage.
- Amazon EBS gp3 volume dynamically provisioned.
- EBS CSI Driver used for storage integration.
- Backend connects to PostgreSQL through Kubernetes internal networking.

The backend health endpoint confirms successful database connectivity.

### 7. Continuous Integration (CI)

GitHub Actions automates the build and validation workflow.

Implemented pipeline capabilities:

- Frontend dependency installation and production build.
- Backend dependency installation and Python syntax validation.
- Docker image builds for frontend and backend.
- AWS authentication using GitHub Actions OIDC.
- Publishing application images to Amazon ECR.
- Git SHA-based Docker image tagging.

### 8. Continuous Deployment (CD) — EC2 Implementation

An automated deployment workflow was previously implemented for the Docker Compose-based EC2 environment.

The workflow includes:

1. GitHub Actions builds application images.
2. Images are pushed to Amazon ECR.
3. GitHub Actions authenticates with AWS using OIDC.
4. AWS Systems Manager triggers deployment commands on EC2.
5. Deployment scripts pull the required image versions.
6. Docker Compose updates application containers.
7. Backend health checks verify deployment.
8. GitHub Actions reports the deployment result.

The deployment script includes an automatic rollback mechanism that restores previously running image versions when deployment fails.

**Rollback testing:** An invalid image tag was deliberately used to test the failure path. The image pull failed, rollback was triggered, and the previously running application remained available.

The EC2 deployment represents the earlier deployment architecture; Kubernetes deployment automation is a future enhancement.

### 9. Application Health Verification

End-to-end application connectivity has been verified through the public ALB.

Frontend test:

```powershell
curl.exe -i http://<ALB-DNS>/
```

Backend and database connectivity test:

```powershell
curl.exe -i http://<ALB-DNS>/api/health
```

Expected response:

```json
{
  "status": "ok",
  "database": "connected"
}
```

Verified request flow:

```text
Browser
  -> AWS ALB
  -> Kubernetes Ingress
  -> Frontend Service
  -> Frontend Pod
  -> Nginx
  -> Backend Service
  -> Backend Pod
  -> PostgreSQL
```

## CI/CD Pipeline Status

| Stage | Implementation | Status |
|---|---|---|
| Source Control | GitHub | Completed |
| Frontend Build | GitHub Actions | Completed |
| Backend Validation | GitHub Actions | Completed |
| Docker Image Build | Docker | Completed |
| AWS Authentication | GitHub OIDC | Completed |
| Image Registry | Amazon ECR | Completed |
| EC2 Deployment | AWS SSM + Docker Compose | Implemented |
| Deployment Health Check | Backend API | Implemented |
| Automatic Rollback | EC2 deployment script | Implemented; initial failure path tested |
| Kubernetes Deployment | Amazon EKS | Completed |
| Persistent Storage | EBS CSI + gp3 | Completed |
| External Access | AWS ALB + Kubernetes Ingress | Completed |
| EKS Automated CD | GitHub Actions integration | Planned |

## AWS Resources

The project uses the following AWS services:

- Amazon VPC
- Amazon EC2
- Amazon EKS
- Amazon ECR
- Amazon EBS
- Elastic Load Balancing (Application Load Balancer)
- AWS IAM
- AWS Systems Manager
- AWS Cloud Networking
- GitHub Actions OIDC integration

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
├── k8s/
│   ├── frontend deployment and service
│   ├── backend deployment and service
│   ├── postgres deployment and storage
│   └── ingress.yaml
│
├── terraform/
│   ├── vpc.tf
│   ├── subnets.tf
│   ├── internet-gateway.tf
│   ├── route-tables.tf
│   ├── security-groups.tf
│   ├── iam.tf
│   ├── eks.tf
│   ├── eks-iam.tf
│   ├── eks-ebs-csi.tf
│   ├── eks-load-balancer-controller.tf
│   ├── ecr.tf
│   └── outputs.tf
│
├── scripts/
│   └── deploy.sh
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

## Current Development Status

| Area | Status |
|---|---|
| Full-Stack Application | Completed |
| Docker Containerization | Completed |
| Docker Compose Deployment | Implemented |
| PostgreSQL Integration | Completed |
| Database Persistence | Implemented |
| AWS VPC and Networking | Implemented |
| Terraform Infrastructure | Implemented; further automation in progress |
| Amazon EKS Cluster | Completed |
| EKS Multi-Node Configuration | Completed |
| Kubernetes Application Deployment | Completed |
| EBS CSI Integration | Completed |
| Persistent EBS Storage | Completed |
| AWS Load Balancer Controller | Completed |
| Kubernetes Ingress | Completed |
| Public ALB Access | Verified |
| Frontend and Backend Connectivity | Verified |
| GitHub Actions CI | Completed |
| GitHub OIDC Authentication | Completed |
| EC2 Continuous Deployment | Implemented |
| EC2 Deployment Rollback | Implemented; initial failure path tested |
| EKS Continuous Deployment | Planned |
| Kubernetes Monitoring | Planned |
| GitOps | Planned |

## Roadmap

- [ ] Integrate GitHub Actions with EKS for automated application deployment.
- [ ] Implement Kubernetes deployment health checks and automated rollback.
- [ ] Implement GitOps using Argo CD.
- [ ] Configure Helm charts for application deployment.
- [ ] Implement Horizontal Pod Autoscaler (HPA).
- [ ] Explore Cluster Autoscaler or Karpenter.
- [ ] Implement Prometheus and Grafana monitoring.
- [ ] Configure centralized application logging.
- [ ] Implement HTTPS using ACM and ALB.
- [ ] Improve Kubernetes security using IAM, RBAC, and network policies.
- [ ] Add application-level smoke and integration tests.
- [ ] Improve infrastructure automation and Terraform state management.

## Project Objective

The objective is to build practical Platform Engineering experience by developing, deploying, and operating a cloud-native application on AWS.

The project demonstrates the complete application lifecycle:

**Source Code → CI/CD → Docker → Amazon ECR → Terraform → Amazon EKS → Kubernetes → AWS ALB → Production-style Application Access**

The focus is not just deploying an application, but understanding how infrastructure, networking, storage, container orchestration, automation, and application services work together in a real cloud environment.