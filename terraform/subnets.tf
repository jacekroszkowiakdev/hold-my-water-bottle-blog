# Subnets in availability zone 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.capstone_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.az1

   tags = {
    Name = "Public Subnet ${var.az1}"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.capstone_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.az1

  tags = {
    Name = "Private Subnet ${var.az1}"
  }
}

# Subnets in availability zone 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.capstone_vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.az2

   tags = {
    Name = "Public Subnet ${var.az2}"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.capstone_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.az2

  tags = {
    Name = "Private Subnet ${var.az2}"
  }
}

# DB subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
  tags = {
    Name = "RDS Subnet Group"
  }
}