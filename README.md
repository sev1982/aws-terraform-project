# 🌍 AWS Terraform Infrastructure Project

## 🧾 Overview
This project automates the deployment of AWS infrastructure using **Terraform**.  
It includes an EC2 instance and uses a **remote backend** with **Amazon S3** (for state storage) and **DynamoDB** (for state locking), following real-world enterprise practices.

---

## 🧱 Project Structure
aws-terraform-project/
├── main.tf → Main infrastructure resources
├── backend.tf → Remote backend configuration (S3 + DynamoDB)
├── variables.tf → Input variables
├── outputs.tf → Output definitions
├── providers.tf → AWS provider setup
├── setup_backend.sh → Script to create S3 and DynamoDB backend
├── user_data.sh → EC2 startup script
└── .gitignore → Git ignore rules

---

## ⚙️ Prerequisites
- **Terraform** ≥ 1.5.0  
- **AWS CLI** installed and configured with a valid profile  
- IAM permissions to create:
  - S3 buckets  
  - DynamoDB tables  
  - EC2 instances  

---

## 🚀 Deployment Steps

### 1️⃣ Create the Remote Backend
Before running Terraform, create the backend resources (S3 + DynamoDB):

```bash
bash setup_backend.sh

This script will:

Create an S3 bucket named terraform-state-severin

Create a DynamoDB table named terraform-locks

Configure backend storage for Terraform

2️⃣ Initialize Terraform

Once the backend exists, initialize Terraform:

terraform init -reconfigure

3️⃣ Validate Configuration
terraform validate

4️⃣ Review the Execution Plan
terraform plan

5️⃣ Apply the Infrastructure
terraform apply -auto-approve


Terraform will create your infrastructure and store the state remotely.

6️⃣ Destroy Resources

To delete all created resources:

terraform destroy -auto-approve

🧠 Backend Details

State Storage: S3 bucket → terraform-state-severin

State Locking: DynamoDB table → terraform-locks

Region: us-east-1

This ensures safe collaboration and avoids state conflicts when multiple users work on the same infrastructure.

🧰 Example EC2 Resource
resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = file("user_data.sh")

  tags = {
    Name = "Terraform-EC2-Server"
  }
}

🧹 .gitignore Example
.terraform/
.terraform.lock.hcl
terraform.tfstate
terraform.tfstate.backup
*.tfvars
crash.log
*.pem

👤 Author

Séverin Kouemo Pouankam
Infrastructure as Code | AWS | Terraform | DevOps
📧 severin.kouemo@yahoo.fr
🌐 www.linkedin.com/in/severin-kouemo-pouankam