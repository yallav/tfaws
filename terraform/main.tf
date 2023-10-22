variable "region" {
    default = "us-east-2"
}

provider "aws" { }

resource "aws_instance" "web" {
  ami                    = "ami-0df435f331839b2d6"
  instance_type          = "t2.micro"
  tags = {
    Name = "first-tf-instance"
  }
}