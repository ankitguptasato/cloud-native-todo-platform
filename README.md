# Cloud-Native Todo Platform on AWS

A hands-on Platform Engineering project built around a React + FastAPI + PostgreSQL application.

The goal of this project is to take a working full-stack application and progressively transform it into a cloud-native platform using **Docker, Kubernetes, AWS, Terraform, CI/CD, observability, and security practices**.

This project is being built as a practical learning and portfolio project with a strong focus on understanding **how the platform works, how services communicate, how failures are diagnosed, and how infrastructure is automated**.

## Project Goal

The application starts as a simple three-tier application:

```text
React
  ↓
Nginx
  ↓
FastAPI
  ↓
PostgreSQL
```

The target architecture is:

```text
                         GitHub
                            │
                            ▼
                     GitHub Actions
                            │
                     Build / Test
                            │
                            ▼
                           ECR
                            │
                            ▼
                         AWS EKS
                     ┌──────┴──────┐
                     │             │
                     ▼             ▼
                Frontend       Backend
                Service        Service
                     │             │
                     │             ▼
                     │        PostgreSQL
                     │          / RDS
                     │
                     ▼
                  Ingress
                     │
                     ▼
                  Internet
```

Infrastructure will eventually be managed using **Terraform**, while monitoring, logging, security, scaling, and failure recovery will be added as the project develops.

---

## Current Application

The application is a Todo management system consisting of:

| Component           | Technology     |
| ------------------- | -------------- |
| Frontend            | React + Vite   |
| Web server          | Nginx          |
| Backend             | Python FastAPI |
| Database            | PostgreSQL 16  |
| ORM                 | SQLAlchemy     |
| Containerization    | Docker         |
| Local orchestration | Docker Compose |

The application supports:

* Create Todo
* List Todos
* Complete/uncomplete Todo
* Delete Todo
* REST API
* PostgreSQL persistence
* FastAPI OpenAPI documentation
* Health checking

---

## Current Local Architecture

The application currently runs successfully with Docker Compose:

```text
Browser
   │
   │ HTTP :3000
   ▼
Nginx
   │
   │ /api/*
   ▼
FastAPI :8000
   │
   │ SQLAlchemy
   ▼
PostgreSQL :5432
```

Docker Compose provides internal service discovery.

For example, Nginx reaches FastAPI using:

```text
backend:8000
```

rather than an IP address.

FastAPI reaches PostgreSQL using:

```text
db:5432
```

This provides the foundation for understanding how the same application will later use **Kubernetes Services and DNS**.

---

## Local Development

Start the complete application:

```bash
docker compose up --build
```

Application:

```text
http://localhost:3000
```

FastAPI documentation:

```text
http://localhost:8000/docs
```

Health endpoint:

```text
http://localhost:8000/api/health
```

Stop the application:

```bash
docker compose down
```

To also remove the local PostgreSQL volume:

```bash
docker compose down -v
```

> Removing the volume deletes the local PostgreSQL data.

---

## Repository Structure

```text
cloud-native-todo-platform/
│
├── backend/
│   ├── app/
│   ├── Dockerfile
│   └── requirements.txt
│
├── frontend/
│   ├── src/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── package.json
│
├── k8s/
│   └── Kubernetes manifests
│
├── terraform/
│   └── AWS infrastructure
│
├── architecture/
│   └── Architecture diagrams
│
├── docs/
│   ├── how-it-works.md
│   └── architecture.md
│
├── .github/
│   └── workflows/
│
├── docker-compose.yml
├── .env.example
├── .gitignore
└── README.md
```

Some directories will be added progressively as the platform is developed.

---

# Platform Engineering Roadmap

The project will be developed incrementally rather than deploying everything at once.

## Phase 1 — Application Understanding

* Understand React → Nginx → FastAPI → PostgreSQL
* Understand REST API communication
* Understand Docker images and containers
* Understand Docker networking
* Understand health checks
* Understand persistent data

**Status: Complete**

---

## Phase 2 — Kubernetes

Deploy the application to Kubernetes.

Topics:

* Pods
* Deployments
* Services
* ConfigMaps
* Secrets
* Persistent storage
* Readiness probes
* Liveness probes
* Resource requests/limits
* Ingress
* DNS/service discovery

Target:

```text
Ingress
   │
   ├── /
   │    ↓
   │  Frontend Service
   │
   └── /api
        ↓
      Backend Service
             ↓
        PostgreSQL
```

**Status: Planned**

---

## Phase 3 — AWS

Move the Kubernetes platform to Amazon EKS.

Planned AWS services include:

* Amazon VPC
* Public/private subnets
* Internet Gateway
* NAT Gateway
* Amazon EKS
* EC2 managed node groups
* Elastic Load Balancing
* Amazon ECR
* Amazon RDS
* Amazon S3
* CloudWatch
* IAM

**Status: Planned**

---

## Phase 4 — CI/CD

Build an automated delivery pipeline:

```text
Developer
   │
   ▼
GitHub
   │
   ▼
GitHub Actions
   │
   ├── Tests
   ├── Docker build
   ├── Image scan
   └── Push image
          │
          ▼
         ECR
          │
          ▼
         EKS
```

The objective is to understand the complete path from a code change to a running application.

**Status: Planned**

---

## Phase 5 — Infrastructure as Code

Infrastructure will progressively be managed using Terraform.

Planned areas:

* VPC
* Subnets
* Routing
* Security groups
* IAM
* EKS
* Node groups
* ECR
* RDS
* Supporting AWS resources

Target:

```text
Terraform
    │
    ▼
AWS Infrastructure
    │
    ▼
EKS Platform
    │
    ▼
Application
```

**Status: Planned**

---

## Phase 6 — Observability

Add operational visibility through:

* Application logs
* Kubernetes logs
* Metrics
* CloudWatch
* Health checks
* Alerts
* Resource monitoring

The goal is not just to deploy the application, but to understand:

> Is it working?
> If not, why?
> Where did the failure occur?

**Status: Planned**

---

## Phase 7 — Security and Reliability

Planned improvements:

* IAM least privilege
* Kubernetes RBAC
* Kubernetes Secrets
* AWS security groups
* Private networking
* HTTPS/TLS
* Container image scanning
* Non-root containers
* Resource limits
* Network isolation
* Backup and recovery
* Failure testing

**Status: Planned**

---

# Learning Method

This project follows a practical engineering workflow:

```text
Situation
   ↓
Understand the concept
   ↓
Build it
   ↓
Verify it
   ↓
Break it intentionally
   ↓
Troubleshoot
   ↓
Fix it
   ↓
Document what happened
```

The objective is to develop **operational understanding**, rather than simply memorizing cloud commands.

---

# Current Technology Stack

### Application

* React
* Vite
* Nginx
* FastAPI
* Python
* SQLAlchemy
* PostgreSQL

### Platform

* Docker
* Kubernetes
* AWS
* Amazon EKS
* Amazon ECR
* Amazon RDS
* Terraform
* GitHub Actions
* CloudWatch

Technologies will be introduced progressively as the project evolves.

---

# Why This Project?

The project is designed to demonstrate practical Platform/Cloud Engineering skills:

* Containerization
* Kubernetes
* Cloud networking
* AWS infrastructure
* Infrastructure as Code
* CI/CD
* Observability
* Security
* Troubleshooting
* Reliability
* Production-oriented architecture

Rather than building a new application from scratch, the focus is on **designing, deploying, automating, operating, and improving the platform around an existing application**.

---

# Original Application

The initial Todo application was based on the educational project:

**react-fastapi-todo by Saurabh Ahuja**

Original project:

https://github.com/saurabhahuja71/react-fastapi-todo

The original application structure and educational code are being used as the starting point for this independent Platform Engineering project.

Please refer to the original repository and included license information for the original application's licensing and attribution requirements.

---

# Project Status

| Area                                   | Status     |
| -------------------------------------- | ---------- |
| Application running locally            | ✅ Complete |
| Docker Compose                         | ✅ Complete |
| Application architecture understanding | ✅ Complete |
| GitHub repository                      | ✅ Complete |
| Kubernetes deployment                  | 🔄 Next    |
| AWS infrastructure                     | Planned    |
| EKS                                    | Planned    |
| ECR                                    | Planned    |
| CI/CD                                  | Planned    |
| Terraform                              | Planned    |
| Monitoring                             | Planned    |
| Security hardening                     | Planned    |
| Failure testing                        | Planned    |

---

## Author

**Ankit Gupta**

Platform / Cloud Engineering learning project.

GitHub:

https://github.com/ankitguptasato

Repository:

https://github.com/ankitguptasato/cloud-native-todo-platform
