output "bucket_name" {
  description = "S3 bucket holding the built site."
  value       = aws_s3_bucket.site.id
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID, needed for cache invalidations."
  value       = aws_cloudfront_distribution.site.id
}

output "cloudfront_domain_name" {
  description = "CloudFront's own domain name (useful before DNS propagates)."
  value       = aws_cloudfront_distribution.site.domain_name
}

output "site_url" {
  description = "Public URL of the site."
  value       = "https://${var.domain_name}"
}

output "name_servers" {
  description = "Point your domain registrar at these name servers (only set when Terraform creates the hosted zone)."
  value       = var.create_hosted_zone ? aws_route53_zone.site[0].name_servers : []
}

output "github_actions_role_arn" {
  description = "Role ARN for GitHub Actions to assume via OIDC — set this as the AWS_DEPLOY_ROLE_ARN repo secret/variable."
  value       = aws_iam_role.github_actions_deploy.arn
}
