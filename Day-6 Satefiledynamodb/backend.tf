terraform {
  required_version = ">= 1.8.5"
  backend "s3" {
    bucket         = "terraforms3bucketweijglweiofj"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "taosif"
  }
}
