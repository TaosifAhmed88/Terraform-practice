# RDS Creation
resource "aws_db_instance" "name" {
  instance_class = "db.t3.micro"
  identifier = "dbd"   #For naming of database use this which is identifier
  db_name = "dbdatabse"
  engine = "mysql"
  engine_version = "8.0"
  manage_master_user_password = true
  username = "admin"
  parameter_group_name = "default.mysql8.0"
  tags = {Name="stud-db"}  #No need of tags for naming the database
  allocated_storage = 20
  db_subnet_group_name = aws_db_subnet_group.name.id
  vpc_security_group_ids = [ aws_security_group.name.id ]
  skip_final_snapshot = false
  publicly_accessible = false
}

# VPC Creation
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {Name="vpcforrds"}
}
# Subnet1 Creation
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
  tags = {Name="Subnet1"}
  availability_zone = "us-east-1a"
}
# Subnet2 Creation
resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  tags = {Name="Subnet2"}
  availability_zone = "us-east-1b"
}
#Subnet Group
resource "aws_db_subnet_group" "name" {
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  tags = {Name="Subnet Group"}
  depends_on = [ aws_subnet.subnet1, aws_subnet.subnet2]
}

# Security Group
resource "aws_security_group" "name" {
  tags = {Name="CustomSG"}
  vpc_id = aws_vpc.name.id
  description = "Allow 3306 port for mysql"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}