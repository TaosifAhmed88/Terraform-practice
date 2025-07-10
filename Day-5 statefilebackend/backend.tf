terraform {
  backend "s3" {
    bucket = "wierusdjkiuerejkterraform"
    key = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}