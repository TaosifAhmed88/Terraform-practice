provider "aws" {
  
}

# Key-pair is not generating you need to crete first of all the key-pair
resource "aws_key_pair" "keypair" {
  key_name = "key-pairs"
  public_key = file("C:/Users/DELL/.ssh/id_rsa.pub")
}

# VPC
resource "aws_vpc" "customvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {Name="Custom-vpc"}
}

#Subnet-1
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.customvpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {Name="Public_Subnet"}
  map_public_ip_on_launch = true  # if you want EC2 instances launched in this subnet to automatically be assigned a public IP address. Good for "public" subnets.
}

# Internet Gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.customvpc.id
  tags = {Name="IG"}
}

# Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.customvpc.id
  tags = {Name="route_table"}
}

# Edit Routes
resource "aws_route" "editroutes" {
  route_table_id = aws_route_table.route_table.id
  gateway_id = aws_internet_gateway.ig.id
  destination_cidr_block = "0.0.0.0/0"
}

# Subnet Association
resource "aws_route_table_association" "subnet_assoc" {
  route_table_id = aws_route_table.route_table.id
  subnet_id = aws_subnet.subnet1.id
}

# Security Group
resource "aws_security_group" "sg" {
  tags = {Name="SG"}
  vpc_id = aws_vpc.customvpc.id
  ingress {
    description = "Allow 22 Port"
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "Allow 80 port"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

# Instance
resource "aws_instance" "ec2" {
  ami = "ami-0cbbe2c6a1bb2ad63"
  key_name = aws_key_pair.keypair.key_name
  instance_type = "t3.medium"
  vpc_security_group_ids = [ aws_security_group.sg.id ]
  associate_public_ip_address = true
  subnet_id = aws_subnet.subnet1.id
  tags = {Name="EC2 Server"}


  # Connection block describing how the provisioner connects to the given instance  
  connection {
    type = "ssh"
    user = "ec2-user"
    host = self.public_ip
    private_key = file("~/.ssh/id_rsa")
    timeout = "2m"
  }

#   #File Provisoner
#   provisioner "file" {
#     source = "file"
#     destination = "/home/ec2-user/text.txt"  #Use: /home/ec2-user/text.txt
#                       #Or: ~/text.txt (the tilde will expand to /home/ec2-user/)
#   }

#   # Local-Execution Provisioner
#   provisioner "local-exec" {
#     command = "touch files"
#   }

#   # Remote-Execution Provisioner
#   provisioner "remote-exec" {
#     inline = [ 
#         "touch /home/ec2-user/aws.txt",
#         "echo 'Hello from terraforms' >> /home/ec2-user/aws.txt"  # If you do changes in file content then also no changes it will show that's why we are using null-resource
#      ]
#   }
 }

############# Connection block ############
# Your connection block is used for provisioners (remote-exec, file, etc.). 
# If you’re just launching the instance and not using provisioners (i.e., there’s no provisioner "remote-exec" or file, etc.), 
# the connection block is not strictly required. It only becomes essential if you want Terraform to run commands or copy files during terraform apply.


# Solution-1 is to create the null-resource
## Null Resource
resource "null_resource" "run-script" {
  provisioner "remote-exec" {
    
    connection {
      host = aws_instance.ec2.public_ip
      user = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
    }
    inline = [ 
        "echo Hello from terraformsss >> /home/ec2-user/aws.txt"
     ]
  }
  # A map of arbitrary strings that, when changed, will force the null resource to be replaced, re-running any associated provisioners.
  triggers = {
    always_run = timestamp()  # Forces rerun every time
  }
}

#Solution-2 to Re-Run the Provisioner
#Use terraform taint to manually mark the resource for recreation:
# terraform taint aws_instance.server
# terraform apply