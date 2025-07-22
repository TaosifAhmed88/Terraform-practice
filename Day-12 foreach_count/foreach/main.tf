provider "aws" {
  
}

variable "ami" {
  type    = string
  default = "ami-085ad6ae776d8f09c"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "env" {
  type    = list(string)
  default = ["one","three"]
}

resource "aws_instance" "name" {
  ami = var.ami
  instance_type = var.instance_type
  for_each = toset(var.env)
  # for_each --> A meta-argument that accepts a map or a set of strings, and creates an instance for each item in that map or set.
  #  Note: A given block cannot use both count and for_each.
  #toset --> toset converts its argument to a set value.

  tags = {Name=each.value}  # # for a set, each.value and each.key is the same
}

# Notes
######### Why the Shift towards for_each #################

# 1. Resource Identity and Naming
# With for_each, each resource has a stable, descriptive key from the map/set you provide. This makes resource names more meaningful, such as:

# text
# Name = each.key  # "web1", "db1", etc.
# count uses only sequential numbers, resulting in generic names like "server-0", "server-1", which can be hard to relate to real roles or business domains.


# 2. Change Stability and Safety
# Problem with count: If you remove or change items in a list, Terraform may destroy and recreate resources because indices shift. For example, deleting the second item causes all subsequent resources to get new indices, leading to unexpected changes in infrastructure.

# Benefit of for_each: Using keys as identifiers means removing or adding an item only affects the specific resource. All others are left untouched, providing greater predictability and minimizing disruption.


# 3. Support for Non-Homogeneous Resources
# If your resources need unique attributes (e.g., different AMIs, instance types, or tags), for_each lets you pass a map of objects, giving each resource its specific configuration.

# With count, customization is awkward—you’d need complex conditionals or data lookups indexed by count.index.