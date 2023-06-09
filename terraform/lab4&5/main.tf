terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
      }
    }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "lab4" {
  ami = var.image_id
  instance_type = "t2.micro"
  key_name = var.my_key
  subnet_id = aws_subnet.lab4_subnet_1.id
  associate_public_ip_address = true
  security_groups = [ aws_security_group.allow_ssh.id ]
  tags = {
    key = "project"
    value = "lab_4"
    }
}

resource "aws_vpc" "lab4_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    key = "project"
    value = "lab_4"
  }
}

resource "aws_subnet" "lab4_subnet_1" {
  vpc_id = aws_vpc.lab4_vpc.id
  cidr_block = "10.0.10.0/24"
  tags = {
      key = "project"
      value = "lab_4"
  }
}

resource "aws_subnet" "lab4_subnet_2" {
  vpc_id = aws_vpc.lab4_vpc.id
  cidr_block = "10.0.20.0/24"
  tags = {
    key = "project"
    value = "lab_4"
  }
} 

resource "aws_security_group" "allow_ssh" {
  name = "alllow_ssh"
  description = "allow ssh connection to instances"
  vpc_id = aws_vpc.lab4_vpc.id

  ingress {
    description = "Inbound SSH connections"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    key = "project"
    value = "lab_4"
  }
}

resource "aws_route_table" "lab4_rt" {
  vpc_id = aws_vpc.lab4_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab4_gw.id
  }

  tags = {
    key = "project"
    value = "lab_4"
  }
}

resource "aws_route_table_association" "association1" {
  subnet_id = aws_subnet.lab4_subnet_1.id
  route_table_id = aws_route_table.lab4_rt.id

}

resource "aws_route_table_association" "association2" {
  subnet_id = aws_subnet.lab4_subnet_2.id
  route_table_id = aws_route_table.lab4_rt.id

}

resource "aws_internet_gateway" "lab4_gw" {
  vpc_id = aws_vpc.lab4_vpc.id
  tags = {
    key = "project"
    value = "lab_4"
  }
}

variable "image_id" {
  type= string
}

variable "my_key" {
  type = string
}

output "PublicIP" {
  value = aws_instance.lab4.public_ip
}