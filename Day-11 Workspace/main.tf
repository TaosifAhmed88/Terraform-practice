resource "aws_instance" "name" {
  ami = "ami-0150ccaf51ab55a51"
  instance_type = "t3.medium"
}

/*
Subcommands:
    delete    Delete a workspace
    list      List Workspaces
    new       Create a new workspace
    select    Select a workspace
    show      Show the name of the current workspace

When you create new workspace then terraform.tfstate.d directory is created and under this workspace prod will be there.In that prod workspace statefile is stored
*/