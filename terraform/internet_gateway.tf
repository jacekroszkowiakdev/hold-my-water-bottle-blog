resource "aws_internet_gateway" "capstone_igw" {
  vpc_id = aws_vpc.capstone_vpc.id
  tags = {
    Name = "Capstone Blog IG"
  }
}
