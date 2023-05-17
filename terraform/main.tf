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

resource "aws_s3_bucket" "test" {
  bucket = "tf-bucket-rc"

  tags = {
    Name = "terraform test bucket"
  }
}

output "PublicIP" {
  value = aws_instance.server.public_ip
}

output "subnet" {
  value = aws_instance.server.subnet_id
}

output "bucket stuff" {
  value = aws_s3_bucket.test.arn
}