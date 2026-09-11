terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  # State starts local. Once you've applied once, create a small bootstrap
  # bucket + DynamoDB lock table (or an S3-native lock, TF >= 1.9) and
  # uncomment this block, then run `terraform init -migrate-state`.
  #
  # backend "s3" {
  #   bucket       = "jorgemartins-terraform-state"
  #   key          = "personal-site/terraform.tfstate"
  #   region       = "eu-west-1"
  #   use_lockfile = true
  # }
}
