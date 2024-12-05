resource "aws_security_group" "capstone_blog_sg" {
     name        = "web-security-group"
     description = "Allow SSH, HTTP, and HTTPS access"
    vpc_id      = aws_vpc.capstone_vpc.id

    # Allow inbound from ports 22, 80 and 443
    ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # Allow all protocols
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Capstone Blog SG"
  }
}

# RDS MariaDB sg
resource "aws_security_group" "rds_mariadb_sg" {
  name        = "rds-security-group"
  description = "Allow database access"

  ingress {
    from_port   = 3306    # MariaDB uses port 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "RDS Security Group"
  }
}