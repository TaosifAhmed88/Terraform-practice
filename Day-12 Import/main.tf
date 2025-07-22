provider "aws" {

}

resource "aws_instance" "ec2" {
  ami = "ami-0cbbe2c6a1bb2ad63"
  instance_type = "t3.micro"
  tags = {Name="Manual_ec2"}
}

# terraform import aws_instance.ec2 i-01d8d3472c76aac75  --> is used to bring an existing AWS EC2 instance (with the ID i-01d8d3472c76aac75) under Terraform management by associating it with the Terraform resource block named aws_instance.ec2 in your configuration.