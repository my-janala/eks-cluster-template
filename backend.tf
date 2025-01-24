terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "env-template-repo/staging/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "your-lock-table"
  }
}