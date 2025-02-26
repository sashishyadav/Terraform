terraform {
  backend "s3" {
    bucket         = "tfstate-lambda-ram"
    key            = "/statefiles"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
