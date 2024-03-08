terraform {
  backend "s3" {
    bucket         = "tf-backend-museelver"
    key            = "tf-backend-museelver/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tf-lock-museelver"
  }
}




