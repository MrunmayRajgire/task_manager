#!/bin/bash

# Exit on error
set -e

# Load environment variables
if [ -f .env ]; then
    source .env
fi

# Check required environment variables
required_vars=(
    "AWS_ACCESS_KEY_ID"
    "AWS_SECRET_ACCESS_KEY"
    "DB_USERNAME"
    "DB_PASSWORD"
    "JWT_SECRET"
)

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Error: $var is not set"
        exit 1
    fi
done

# Configure AWS CLI
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set region ap-south-1

# Login to ECR
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com

# Build and push backend image
echo "Building and pushing backend image..."
docker build -t task-management-backend ./backend
docker tag task-management-backend:latest $AWS_ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/task-management-backend:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/task-management-backend:latest

# Build and push frontend image
echo "Building and pushing frontend image..."
docker build -t task-management-frontend ./frontend
docker tag task-management-frontend:latest $AWS_ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/task-management-frontend:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/task-management-frontend:latest

# Initialize and apply Terraform
echo "Applying Terraform configuration..."
cd terraform
terraform init \
    -backend-config="bucket=task-management-terraform-state" \
    -backend-config="key=terraform.tfstate" \
    -backend-config="region=ap-south-1"

terraform apply -auto-approve \
    -var="db_username=$DB_USERNAME" \
    -var="db_password=$DB_PASSWORD" \
    -var="jwt_secret=$JWT_SECRET"

# Get the application URL
echo "Getting application URL..."
ALB_DNS=$(aws elbv2 describe-load-balancers --names task-management-alb --query 'LoadBalancers[0].DNSName' --output text)
echo "Application deployed successfully!"
echo "Frontend URL: http://$ALB_DNS"
echo "Backend API URL: http://$ALB_DNS/api" 