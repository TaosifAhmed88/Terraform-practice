#RDS Creation
resource "aws_db_instance" "name" {
  identifier = "staff-db"
  db_name = "mydb"
  engine = "mysql"
  engine_version = "8.0.41"
  parameter_group_name = "default.mysql8.0"
  instance_class = "db.t3.micro"
  username = "taosif"
  password = "taosif*123"
  allocated_storage = "30"
  publicly_accessible = false
}

# VPC for RDS
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {Name="VPC for RDS"}
}

# Subnets of VPC for RDS
resource "aws_subnet" "subnet_1" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.name.id
  tags = {Name="Subnet_1"}
  availability_zone = "us-east-1a"
}
resource "aws_subnet" "subnet_2" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  tags = {Name="Subnet_2"}
  availability_zone = "us-east-1b"
}

# Subnet Group for RDS
resource "aws_db_subnet_group" "name" {
  name = "subnet_group"
  subnet_ids = [ aws_subnet.subnet_1.id, aws_subnet.subnet_2.id ]
  tags = {Name="My Subnet Group"}
  depends_on = [ aws_subnet.subnet_1, aws_subnet.subnet_2]
}


