#!/bin/bash

###############################################
# 🚀 Terraform Remote Backend Setup Script
# Author: Séverin Kouemo
# Description: Creates an AWS S3 bucket and DynamoDB
# table for Terraform remote backend storage and locking.
###############################################

# ---- Configuration ----
AWS_REGION="us-east-1"
BUCKET_NAME="terraform-state-severin"
DYNAMO_TABLE="terraform-locks"

echo "========================================"
echo "🔹 Setting up Terraform remote backend"
echo "Region: $AWS_REGION"
echo "S3 Bucket: $BUCKET_NAME"
echo "DynamoDB Table: $DYNAMO_TABLE"
echo "========================================"

# ---- Check if AWS CLI is installed ----
if ! command -v aws &> /dev/null
then
    echo "❌ AWS CLI not found. Please install it before running this script."
    exit 1
fi

# ---- Check if bucket exists ----
echo "🪣 Checking if S3 bucket already exists..."
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "✅ Bucket '$BUCKET_NAME' already exists."
else
    echo "🪣 Creating S3 bucket..."
    aws s3api create-bucket \
        --bucket "$BUCKET_NAME" \
        --region "$AWS_REGION" \
        --create-bucket-configuration LocationConstraint="$AWS_REGION"

    echo "🔐 Enabling default encryption..."
    aws s3api put-bucket-encryption \
        --bucket "$BUCKET_NAME" \
        --server-side-encryption-configuration '{
            "Rules": [
                {"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}
            ]
        }'

    echo "🚫 Blocking public access..."
    aws s3api put-public-access-block \
        --bucket "$BUCKET_NAME" \
        --public-access-block-configuration '{
            "BlockPublicAcls": true,
            "IgnorePublicAcls": true,
            "BlockPublicPolicy": true,
            "RestrictPublicBuckets": true
        }'

    echo "🕒 Enabling versioning..."
    aws s3api put-bucket-versioning \
        --bucket "$BUCKET_NAME" \
        --versioning-configuration Status=Enabled

    echo "✅ S3 bucket '$BUCKET_NAME' created successfully."
fi

# ---- Check if DynamoDB table exists ----
echo "💾 Checking if DynamoDB table already exists..."
if aws dynamodb describe-table --table-name "$DYNAMO_TABLE" --region "$AWS_REGION" >/dev/null 2>&1; then
    echo "✅ DynamoDB table '$DYNAMO_TABLE' already exists."
else
    echo "💾 Creating DynamoDB table..."
    aws dynamodb create-table \
        --table-name "$DYNAMO_TABLE" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST \
        --region "$AWS_REGION"

    echo "⏳ Waiting for DynamoDB table to be active..."
    aws dynamodb wait table-exists --table-name "$DYNAMO_TABLE" --region "$AWS_REGION"
    echo "✅ DynamoDB table '$DYNAMO_TABLE' created successfully."
fi

# ---- Initialize Terraform with new backend ----
echo "⚙️  Initializing Terraform backend..."
terraform init -reconfigure

echo "========================================"
echo "🎉 Terraform backend setup complete!"
echo "State will be stored remotely in:"
echo "➡️  S3 Bucket: $BUCKET_NAME"
echo "➡️  DynamoDB Table: $DYNAMO_TABLE"
echo "========================================"
