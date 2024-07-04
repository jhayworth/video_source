terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.57.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "test_server" {
  ami                     = "ami-0aff18ec83b712f05"
  instance_type           = "t3.micro"
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = var.vpc_security_group_ids
  key_name                = var.key_name
    
  instance_market_options {
    market_type = "spot"

    spot_options {
      max_price = 0.005
    }
  }

  tags = {
    Name = "Test_Server_Instance"
  }

  provisioner "local-exec" { command = "scripts/prepare-ansible-inventory.sh test_server ${aws_instance.test_server.public_ip}" }
}