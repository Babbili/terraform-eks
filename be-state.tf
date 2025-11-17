terraform {
  backend "s3" {
    bucket         = "ddtf-829edc6faa0853fdcb"
    key            = "dd/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate-locks"
  }
}

