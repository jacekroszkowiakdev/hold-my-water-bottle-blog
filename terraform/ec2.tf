# resource "aws_key_pair" "labsuser" {
#   key_name   = "vockey"
#   public_key = file("${abspath(path.cwd)}/labsuser.pem")
# }

resource "aws_instance" "wordpress_instance" {
  ami                    = "ami-00d72ec36cdfc8a0a"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.vockey.key_name
  subnet_id             = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.capstone_blog_sg.id]

  tags = {
    Name = "WordPress Blog EC2 Instance"
  }

  # Read the userData.sh file
  user_data = file("${path.module}/../scripts/userDataEC2.sh")
}