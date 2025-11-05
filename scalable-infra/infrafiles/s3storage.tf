# Random string for unique bucket naming
resource "random_string" "bucket_id" {
  length  = 8
  special = false
  upper   = false
}

#s3 for storage
resource "aws_s3_bucket" "product_bucket" {
  bucket = "product-${random_string.bucket_id.result}" # Change to a globally unique name
  tags = {
    Name        = "My S3 Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "product_bucket_public_access_block" {
  bucket = aws_s3_bucket.product_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Ensure ownership is bucket-owner enforced (modern requirement)
resource "aws_s3_bucket_ownership_controls" "product_bucket_ownership_controls" {
  bucket = aws_s3_bucket.product_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}