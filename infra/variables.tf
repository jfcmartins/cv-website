variable "aws_region" {
  description = "AWS region for the S3 bucket and non-global resources."
  type        = string
  default     = "eu-west-1"
}

variable "domain_name" {
  description = "Apex domain for the site, e.g. jorgemartins.xyz"
  type        = string
}

variable "include_www" {
  description = "Also serve the site on www.<domain_name> and redirect it to the apex (or vice versa)."
  type        = bool
  default     = true
}

variable "create_hosted_zone" {
  description = "Whether Terraform should create the Route53 hosted zone. Set to false if the zone already exists and pass its ID via hosted_zone_id."
  type        = bool
  default     = true
}

variable "hosted_zone_id" {
  description = "Existing Route53 hosted zone ID to use when create_hosted_zone is false."
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "GitHub repo allowed to assume the deploy role via OIDC, in \"owner/repo\" form."
  type        = string
}

variable "create_github_oidc_provider" {
  description = "Whether to create the GitHub Actions OIDC provider. AWS allows only one per account for token.actions.githubusercontent.com — set to false and it will be looked up instead if one already exists."
  type        = bool
  default     = true
}
