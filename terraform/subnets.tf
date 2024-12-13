# Subnets in availability zone 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.capstone_vpc.id
  cidr_block              = var.public_subnets[1]
  map_public_ip_on_launch = true
  availability_zone       = var.az_primary

   tags = {
    Name = "Public Subnet ${var.az_primary}"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.capstone_vpc.id
  cidr_block              = var.private_subnets[1]
  availability_zone = var.az_primary

  tags = {
    Name = "Private Subnet ${var.az_primary}"
  }
}

# Subnets in availability zone 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.capstone_vpc.id
  cidr_block              = var.public_subnets[2]
  map_public_ip_on_launch = true
  availability_zone       = var.az_secondary

   tags = {
    Name = "Public Subnet ${var.az_secondary}"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.capstone_vpc.id
  cidr_block              = var.private_subnets[2]
  availability_zone = var.az_secondary

  tags = {
    Name = "Private Subnet ${var.az_secondary}"
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