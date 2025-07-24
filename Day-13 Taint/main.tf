#Solution-2 to Re-Run the Provisioner
#Use terraform taint to manually mark the resource for recreation:
# terraform taint aws_instance.server
# terraform apply
# If no changes is there but you tainted it.
# Server will be destroyed and created

provider "aws" {
  
}

resource "aws_instance" "server" {
  ami = "ami-0cbbe2c6a1bb2ad63"
  instance_type = "t3.medium"
  tags = {Name="Server-1"}
}