resource "aws_s3_bucket" "eks-backend" {
  bucket        = "eks-backend"
  force_destroy = true

  tags = {
    Name        = "eks-backend"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.eks-backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "eks-backend" {
  bucket = aws_s3_bucket.eks-backend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "eks-backend-dynamodb-table" {
  name         = "eks-backend-dynamodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"


  attribute {
    name = "LockID"
    type = "S"
  }
} 