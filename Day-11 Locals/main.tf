locals {
  instance_type = "t2.micro"
  region = "us-east-1"
}
resource "aws_instance" "name" {
  ami = "ami-0150ccaf51ab55a51"
  instance_type = local.instance_type
  tags = {
    Name = "App-${local.region}"
  }
}

/*
Typical Use Cases
Creating dynamic names or tags for resources.

Storing results of complex expressions.

Composing frequently used or calculated data into a single value to avoid repetition.

Grouping common logic or configuration, especially for tags, naming, or conditional logic
*/