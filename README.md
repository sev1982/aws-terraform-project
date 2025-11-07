## version française

# Projet Terraform AWS – Serveur Web (Free Tier)

##  Objectif
Déployer une infrastructure complète AWS avec Terraform :
- 1 VPC
- 1 Subnet public et 1 privé
- 1 Internet Gateway
- 1 Route Table
- 1 Security Group (HTTP + SSH)
- 1 EC2 avec Apache Web Server

---

## ⚙️ Commandes de base
```bash
terraform init
terraform validate
terraform plan
terraform apply


## version anglaise

# Terraform AWS Project – Web Server (Free Tier)

##  Objective
Deploy a  complete AWS infrastructure using **Terraform** (compatible with the AWS Free Tier).

This project automatically provisions:
- 1 Virtual Private Cloud (VPC)
- 1 Public Subnet and 1 Private Subnet
- 1 Internet Gateway and Route Table
- 1 Security Group (allowing HTTP + SSH)
- 1 EC2 instance running a simple Apache web server

---

##  Prerequisites
Before starting, make sure you have:
- An **AWS account** (Free Tier works)
- **Terraform** installed (`terraform -version`)
- **AWS CLI** configured (`aws configure`)
- A **key pair** created in AWS (name it `terraform-key`)
- **Visual Studio Code** or any IDE you like

---

##  Project Structure

terraform-aws-project/
├── main.tf # Main infrastructure configuration
├── provider.tf # AWS provider and Terraform settings
├── outputs.tf # Outputs such as public IP or URL
├── user-data.sh # Bash script to configure EC2 instance
├── variables.tf # (Optional) variables for modularity
└── README.md # Project documentation
