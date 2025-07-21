provider "aws" {
  
}

resource "aws_security_group" "name" {
  description = "Multiple Ports allowed in single SG"
  ingress = [ 
    for port in [80, 443, 22, 8080, 9000, 8081, 3000] : {
        description = "inbound rules"
        from_port = port
        to_port = port
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false

        # These four attributes are neccesary viz ipv6_cidr_blocks,prefix_list_ids,security_groups,self=false
        # When you use a for-expression to generate ingress (or egress) rules in an AWS security group resource in Terraform (i.e., when you assign a list of objects to the ingress argument), all attributes of the object type must be explicitly defined.
    }
  ]
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {Name="SG-Group"}
}