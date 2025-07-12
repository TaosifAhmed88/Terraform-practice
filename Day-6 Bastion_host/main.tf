#Custom Network

# Creation of VPC
resource "aws_vpc" "vpcname" {
  tags = {Name="Custom_Vpc"}
  cidr_block = "10.0.0.0/16"
}

# Public Subnet Creation 
resource "aws_subnet" "public_name" {
  vpc_id = aws_vpc.vpcname.id
  tags = {Name="Public_subnet"}
  availability_zone = "us-west-2a"
  cidr_block = "10.0.0.0/26"
}

# Private Subnet Creation 
resource "aws_subnet" "private_name" {
  vpc_id = aws_vpc.vpcname.id
  tags = {Name="Private_subnet"}
  availability_zone = "us-west-2b"
  cidr_block = "10.0.0.64/26"
}

# Route Table Public Creation
resource "aws_route_table" "rtpublic_name" {
  tags = {Name="rt_public"}
  vpc_id = aws_vpc.vpcname.id
}

# Route Table private Creation
resource "aws_route_table" "rtprivate_name" {
  tags = {Name="rt_private"}
  vpc_id = aws_vpc.vpcname.id
}

#IG
resource "aws_internet_gateway" "ig_name" {
  tags = {Name="custom_ig"}
  vpc_id = aws_vpc.vpcname.id
}

# Edit Routes public creation
resource "aws_route" "route_public_name" {
  route_table_id = aws_route_table.rtpublic_name.id
  gateway_id = aws_internet_gateway.ig_name.id
  destination_cidr_block = "0.0.0.0/0"
  
}
# Edit Routes private creation
resource "aws_route" "route_private_name" {
  route_table_id = aws_route_table.rtprivate_name.id
  gateway_id = aws_internet_gateway.ig_name.id
  destination_cidr_block = "0.0.0.0/0"
  
}

# Subnet Association Public Route table
resource "aws_route_table_association" "subnet_assoc_public_name" {
  route_table_id = aws_route_table.rtpublic_name.id
  subnet_id = aws_subnet.public_name.id
}

# Subnet Association private Route table
resource "aws_route_table_association" "subnet_assoc_private_name" {
  route_table_id = aws_route_table.rtprivate_name.id
  subnet_id = aws_subnet.private_name.id
}

# Elatic IP Allocation 
resource "aws_eip" "nat_eip_name" {
  domain = "vpc"
  tags = {Name="nat-eip"}
}
# NAT Gateway Creation
resource "aws_nat_gateway" "name" {
  subnet_id = aws_subnet.public_name.id
  tags = {Name="NAT_Gateway"}
  connectivity_type = "public"
  allocation_id = aws_eip.nat_eip_name.id
  depends_on = [ aws_internet_gateway.ig_name ]
}

# import {
#   to = aws_eip.nat_eip_name
#   id = "eipalloc-0bd112611430c4bb0"
# }

# Security Group
resource "aws_security_group" "sg_name" {
  tags = {Name="SG_group"}
  vpc_id = aws_vpc.vpcname.id
  description = "Allow port 22"
  ingress {
    from_port = 22
    to_port = 22
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
# Public EC2 Creation
resource "aws_instance" "public_instance_name" {
  ami = "ami-0be5f59fbc80d980c"
  tags = {Name="Public_Server"}
  instance_type = "t3.micro"
  key_name = "keys"
  vpc_security_group_ids = [ aws_security_group.sg_name.id ]
  subnet_id = aws_subnet.public_name.id
  associate_public_ip_address = true

}
# Private Ec2 Creation
resource "aws_instance" "private_instance_name" {
  ami = "ami-0be5f59fbc80d980c"
  tags = {Name="Private_Server"}
  instance_type = "t3.micro"
  key_name = "keys"
  vpc_security_group_ids = [aws_security_group.sg_name.id]
  subnet_id = aws_subnet.private_name.id
  associate_public_ip_address = false
}

