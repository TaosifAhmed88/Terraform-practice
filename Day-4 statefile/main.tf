resource "aws_instance" "name" {
  ami                    = "ami-05ee755be0cd7555c"                 # Use a valid AMI ID
  instance_type          = "t2.medium"
  subnet_id              = "subnet-0946faf4522477978"              # Replace with your subnet ID
  vpc_security_group_ids = ["sg-01b5e6cb9aa01aaac"]              # Replace with your SG ID
}
