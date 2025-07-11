#VPC Creation
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC"
  }
}

#Subnet 1
resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "subnet-public"
  }
}

#Route table
resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id
  tags = {Name="public-rt"}
}
#IG
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id
  tags = {Name="ig"}
}

#Edit Routes
resource "aws_route" "name" {
  gateway_id = aws_internet_gateway.name.id
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = aws_route_table.name.id
}

#Subnet Association
resource "aws_route_table_association" "name" {
  subnet_id = aws_subnet.name.id
  route_table_id = aws_route_table.name.id
}

#Security Group
resource "aws_security_group" "name" {
    vpc_id = aws_vpc.name.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = [ "10.0.0.0/24" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {Name="sg-group"}
}

resource "aws_instance" "name" {
  ami = "ami-05ffe3c48a9991133"
  instance_type = "t3.medium"
  subnet_id = aws_subnet.name.id
  vpc_security_group_ids = [ aws_security_group.name.id ]
  associate_public_ip_address = true
  tags = {Name="Server"}

}
