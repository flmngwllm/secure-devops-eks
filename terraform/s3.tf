resource "aws_s3_bucket" "sercure_devops_ci_artifacts" {
  bucket        = "secure-devops-artifacts"
  force_destroy = true

  tags = {
    Name = "CI Artifacts Bucket"
  }
}


resource "aws_s3_bucket_policy" "sercure_devops_ci_artifacts_policy" {
  bucket = aws_s3_bucket.sercure_devops_ci_artifacts.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowGitHubActionsAccess",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::831274730062:role/github-actions-role"
        },
        Action   = ["s3:CreateBucket", "s3:GetObject", "s3:PutObject", "s3:ListBucket"],
        Resource = "${aws_s3_bucket.sercure_devops_ci_artifacts.arn}/*"
      },
      {
        Sid    = "AllowBucketOperations",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::831274730062:role/github-actions-role"
        },
        Action = [
          "s3:ListBucket",
          "s3:CreateBucket"
        ],
        Resource = "${aws_s3_bucket.sercure_devops_ci_artifacts.arn}"
      }
    ]
  })
}