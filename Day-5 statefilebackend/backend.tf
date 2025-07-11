terraform {
  backend "s3" {
    bucket = "terraforms3bucketweijgl"
    key = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
    encrypt = true

  }
}