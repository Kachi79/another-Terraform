terraform {
  backend "s3" {
    bucket         = "js1-backend"
    key            = "global/S3/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "js1-backend-dynamodb"
    encrypt        = true
  }
}