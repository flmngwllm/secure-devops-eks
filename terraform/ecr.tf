resource "aws_ecr_repository" "secure_app_repo" {
  name                 = "secure-app"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "secure-app-ecr"
  }
}