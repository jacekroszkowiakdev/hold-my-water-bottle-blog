# Define the VPC
resource "aws_vpc" "capstone_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "cycling blog VPC"
  }
}

# Subnet in availability zone 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.az1

   tags = {
    Name = "Public Subnet ${var.az1}"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.az1

  tags = {
    Name = "Private Subnet ${var.az1}"
  }
}

# Subnet in availability zone 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.az2

   tags = {
    Name = "Public Subnet ${var.az2}"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.az2

  tags = {
    Name = "Private Subnet ${var.az2}2"
  }
}

