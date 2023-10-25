provider "aws" { }

variable "instance_name" {
  type = string
  default = "test"
  description = "Value of the Name tag for EC2 instance"
}

variable "instance_count" {
  type = number
  default = 1
}

resource "aws_instance" "web_server" {
  count = var.instance_count
  ami           = "ami-0df435f331839b2d6"
  instance_type = "t2.micro"
  tags = {
    Name = "${var.instance_name}-${count.index}"
  }
}

output "instance_id" {
  value = aws_instance.web_server.*.id
  description = "ID of the EC2 instance"
}

output "instance_public_ip" {
  value = aws_instance.web_server.*.public_ip
  description = "Public IP address of the EC2 instance"
}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      web_servers = aws_instance.web_server.*.public_ip
    }
  )
  filename = "../ansible/hosts.ini"
}
