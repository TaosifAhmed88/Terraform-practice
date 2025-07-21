resource "aws_instance" "name" {
  ami = "ami-0150ccaf51ab55a51"
  tags = {Name="instance"}
  instance_type = "t2.micro"
  user_data = file("instance.sh")

}
# terraform destroy -target aws_instance.name -auto-approve  ---> We can destroy specific resource