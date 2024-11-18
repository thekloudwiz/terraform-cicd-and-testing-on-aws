# Instructions: Place your provider configuration below
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # Instructions: Add S3 Remote Backend Configuration

  # Instructions: After first running `terraform apply`, uncomment the block below, full in the desired values, and re-run 'terraform apply' to configure your S3 Remote Backend.
  # IMPORANT! - Ensure the resources you are referencing (S3 Bucket and DynamoDB table) already exist in the AWS account and region you are currently in or it will fail.

  backend "s3" {
    bucket         = "example-prod-workload-tf-state-620w"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "example-prod-workload-tf-state-lock-vtvp"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Management = "Terraform"
    }
  }
}