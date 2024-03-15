resource "aws_s3_bucket" "js1-backend" {
  bucket        = "js1-backend"
  force_destroy = true

  tags = {
    Name        = "js1-backend"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.js1-backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "js-backend" {
  bucket = aws_s3_bucket.js1-backend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "js1-backend-dynamodb-table" {
  name         = "js1-backend-dynamodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"


  attribute {
    name = "LockID"
    type = "S"
  }
} 