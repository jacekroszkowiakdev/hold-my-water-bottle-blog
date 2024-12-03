# Define the VPC
resource "aws_vpc" "capstone_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "cycling blog VPC"
  }
}

# Subnet in eu-central-1a
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1a"
}

# Subnet in eu-central-1b
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1b"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-central-1b"
}

