###############################################
# 🔹 Terraform Backend Configuration
###############################################

terraform {
  backend "s3" {
    bucket         = "terraform-state-severin"
    key            = "aws-infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
