resource "aws_instance" "name" {
  ami = var.ami
  instance_type = var.aws_instance
  key_name = "key"
}