provider "aws" {
  
}

variable "allowed_ports" {
  type = map(string)
  default = {
    "22" = "10.0.0.0/16"
    "80" = "123.0.0.0/24"
  }
}

resource "aws_security_group" "name" {
  description = "ALlow speccific ports"
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
        description = "Allow access to port ${ingress.key}"
      from_port = ingress.key
      to_port = ingress.key
      protocol = "tcp"
      cidr_blocks = [ ingress.value ]
    }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}