# DevOps Task Management Application

A modern task management web application with complete DevOps integration.

## Tech Stack

- Frontend: React with TypeScript
- Backend: Node.js with Express
- Database: PostgreSQL
- Infrastructure: Terraform on AWS
- CI/CD: GitHub Actions
- Containerization: Docker

## Project Structure

```
.
├── frontend/           # React TypeScript frontend
├── backend/           # Node.js Express backend
├── terraform/         # Infrastructure as Code
├── .github/          # GitHub Actions workflows
└── docker/           # Docker configuration files
```

## Getting Started

### Prerequisites

- Node.js >= 18
- Docker & Docker Compose
- Terraform >= 1.0
- AWS CLI configured
- PostgreSQL

### Local Development

1. Clone the repository
2. Install dependencies:
   ```bash
   cd frontend && npm install
   cd ../backend && npm install
   ```
3. Start the development environment:
   ```bash
   docker-compose up
   ```

### Infrastructure Deployment

1. Initialize Terraform:
   ```bash
   cd terraform
   terraform init
   ```

2. Apply infrastructure:
   ```bash
   terraform plan
   terraform apply
   ```

## Features

- Task creation, updating, and deletion
- Project organization
- User authentication and authorization
- Real-time updates
- Task assignments and due dates
- Progress tracking
- File attachments
- Activity logging

## DevOps Features

- Infrastructure as Code with Terraform
- Automated CI/CD pipeline
- Container orchestration
- Automated testing
- Monitoring and logging
- High availability setup
- Disaster recovery 