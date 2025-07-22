provider "aws" {
  
}

resource "aws_instance" "name" {
  ami = "ami-05ffe3c48a9991133"
  instance_type = "t3.medium"

}
resource "aws_s3_bucket" "s3" {
  bucket = "sfjerinfvweifj"
}

# terraform plan -target aws_s3_bucket.s3 --> Only specific resource will be created
# terraform apply -auto-approve -target aws_s3_bucket.s3 --> Only specific resource will be created