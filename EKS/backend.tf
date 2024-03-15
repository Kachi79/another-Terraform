terraform {
  backend "s3" {
    bucket         = "eks-backend"
    key            = "global/S3/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "eks-backend-dynamodb"
    encrypt        = true
  }
}