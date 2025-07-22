provider "aws" {
  
}

############## Example-1 name with count #############
# resource "aws_instance" "name" {
#   ami = "ami-0cbbe2c6a1bb2ad63"
#   instance_type = "t3.medium"
#   count = 3
#   tags = {Name="Dev-${count.index}"}
# }

############ Example-2 Different names #############
# variable "instance-name" {
#   type = list(string)
#   default = [ "dev","prod","test" ]
# }

# resource "aws_instance" "name" {
#   ami = "ami-0cbbe2c6a1bb2ad63"
#   instance_type = "t3.medium"
#   count = length(var.instance-name)   #3
#   tags = {
#     Name = var.instance-name[count.index]
#     }
# }


###### example-3 creating IAM users ################
variable "iam-user" {
    type = list(string)
    default = [ "user-1","user2","user-3" ]
} 

resource "aws_iam_user" "iam" {
  count = length(var.iam-user)
  name = var.iam-user[count.index]
}
