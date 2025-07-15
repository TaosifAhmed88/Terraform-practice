# RDS Creation
resource "aws_db_instance" "name" {
  instance_class = "db.t3.micro"
  identifier = "staff-db"
  engine = "mysql"
  engine_version = "8.0.41"
  db_name = "db_1"
  username = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials_version.secret_string)["username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials_version.secret_string)["password"]
  parameter_group_name = "default.mysql8.0"
  allocated_storage = 20
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.name.id
  vpc_security_group_ids = [ aws_security_group.name.id ]
  skip_final_snapshot = true

}

# VPC for RDS
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {Name="Vpcrds"}
}

# Subnet 1 for RDS
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
  tags = {Name="Subnet-1"}
  availability_zone = "us-east-1a"
}

# Subnet 2 for RDS
resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  tags = {Name="subnet-2"}
  availability_zone = "us-east-1b"
}

# Subnet Group for RDS
resource "aws_db_subnet_group" "name" {
  subnet_ids = [ aws_subnet.subnet1.id, aws_subnet.subnet2.id ]
  name = "subnet-group"
  depends_on = [ aws_subnet.subnet1, aws_subnet.subnet2 ]
}

# Security Group for RDS
resource "aws_security_group" "name" {
  description = "Allow 3306 port"
  vpc_id = aws_vpc.name.id
  tags = {Name="SG"}
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
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

# Only Calling Secrets from Secret Manager
data "aws_secretsmanager_secret" "rds_credentials" {
  name = "rds-credentials"  # Secret Name
}

data "aws_secretsmanager_secret_version" "rds_credentials_version" {
  secret_id = data.aws_secretsmanager_secret.rds_credentials.id
}

