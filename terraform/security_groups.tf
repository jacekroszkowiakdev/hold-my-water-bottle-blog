resource "aws_security_group" "capstone_blog_sg" {
     name        = "web-security-group"
     description = "Allow SSH, HTTP, and HTTPS access"
    vpc_id      = var.vpc_id

    # Allow inbound from ports 22, 80 and 443
    ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # Replace with more restrictive CIDR if necessary
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