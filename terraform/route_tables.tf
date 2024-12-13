# Route Table for Public Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.capstone_vpc.id

  # Public subnets route to ig
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.capstone_igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Route Table for Private Subnets
resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.capstone_vpc.id

  tags = {
    Name = "Private Route Table ${var.az_primary}"
  }
}

resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.capstone_vpc.id

  tags = {
    Name = "Private Route Table ${var.az_secondary}"
  }
}

# Associate Route Tables with subnets
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table_1.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_2.id
}