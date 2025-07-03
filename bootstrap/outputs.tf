output "github_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github.arn
}

output "github_oidc_provider_url" {
  value = aws_iam_openid_connect_provider.github.url
}

output "ci_artifacts_bucket_name" {
  value = aws_s3_bucket.sercure_devops_ci_artifacts.bucket
}