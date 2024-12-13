resource "aws_vpc" "capstone_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "capstone VPC"
  }
}

