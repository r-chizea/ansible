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

resource "aws_instance" "server" {
  ami = "ami-09744628bed84e434"
  instance_type = "t2.micro"
  key_name = "may23"
  vpc_security_group_ids = [ "sg-08f4fcf84c89e9658", "sg-0b3e6e5107916b871" ]
}
