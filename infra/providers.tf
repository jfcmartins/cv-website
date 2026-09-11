provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "personal-site"
      ManagedBy = "terraform"
    }
  }
}

# CloudFront + ACM require certificates to live in us-east-1, regardless of
# where the rest of the stack is deployed.
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = "personal-site"
      ManagedBy = "terraform"
    }
  }
}
