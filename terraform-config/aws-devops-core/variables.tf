variable "aws_region" {
  type = string
  description = "The AWS region your wish to deploy your resources to."
  default = "us-east-1"
}

variable "github_owner" {
  description = "GitHub repository owner"
  type        = string
  default     = "<github-username>"
}

variable "github_token" {
  type        = string
  sensitive   = true
}


