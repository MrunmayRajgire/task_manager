#!/bin/bash
set -e

# Set variables
AWS_REGION="ap-south-1"
AWS_ACCOUNT_ID="189374110923"
PROJECT_NAME="task-management"
ECR_FRONTEND_REPO="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PROJECT_NAME}-frontend"
ECR_BACKEND_REPO="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PROJECT_NAME}-backend"
ECS_CLUSTER="${PROJECT_NAME}-cluster"
ECS_SERVICE="${PROJECT_NAME}-service"

echo "=== Starting deployment process ==="

# Login to ECR
echo "Logging in to ECR..."
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Build and push frontend image
echo "Building and pushing frontend image..."
cd frontend
docker build -t ${ECR_FRONTEND_REPO}:latest .
docker push ${ECR_FRONTEND_REPO}:latest
cd ..

# Build and push backend image
echo "Building and pushing backend image..."
cd backend
docker build -t ${ECR_BACKEND_REPO}:latest .
docker push ${ECR_BACKEND_REPO}:latest
cd ..

# Force new deployment
echo "Forcing new deployment of ECS service..."
aws ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_SERVICE} --force-new-deployment --region ${AWS_REGION}

echo "=== Deployment initiated ==="
echo "Check deployment status with: aws ecs describe-services --cluster ${ECS_CLUSTER} --services ${ECS_SERVICE} --region ${AWS_REGION}"
echo "Your application will be available at: http://[ALB_DNS_NAME]" 