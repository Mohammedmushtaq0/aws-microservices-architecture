# -------------------------
# ECR Repository
# -------------------------
resource "aws_ecr_repository" "product_v1_repo" {
  name = "product-v1"

  tags = {
    Name = "product-v1-ecr-repo"
  }
}

# -------------------------
# Output ECR Repository URL
# -------------------------
output "ecr_repository_url" {
  value       = aws_ecr_repository.product_v1_repo.repository_url
  description = "URL of the ECR repository"
}
