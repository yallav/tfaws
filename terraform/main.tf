terraform {
  required_providers {
    ansible = {
      version = "~> 1.1.0"
      source  = "ansible/ansible"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" { 
  
}

variable "ssh_key" {
  type = string
  default = "test"
  description = "Public key value to attach to EC2 instances"
}

resource "aws_key_pair" "deployer_ssh_key" {
  key_name = "deployer_key"
  public_key = var.ssh_key
}

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
  // count         = var.instance_count
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  tags = {
    Name = "${var.instance_name}-${count.index}"
  }

  key_name = aws_key_pair.deployer_ssh_key.key_name
}

output "instance_id" {
  value = aws_instance.web_server.id
  description = "ID of the EC2 instance"
}

output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
  description = "Public IP address of the EC2 instance"
}

/* resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      web_servers = aws_instance.web_server.*.public_ip
    }
  )
  filename = "../ansible/inventory"
} */

# Add created ec2 instance to ansible inventory
resource "ansible_host" "web_server" {
  name   = aws_instance.web_server.public_dns
  groups = ["nginx"]
  variables = {
    ansible_user                 = "ubuntu",
    ansible_ssh_private_key_file = "~/.ssh/id_rsa",
    ansible_python_interpreter   = "/usr/bin/python3",
  }
}