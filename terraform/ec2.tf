data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "wordpress_instance" {
  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = var.ec2_instance_type
  key_name               = var.key_name
  subnet_id             = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.capstone_wordpress_sg.id]

  depends_on = [aws_db_instance.multi_az_mariadb]

  tags = {
    Name = "Wordpress Instance"
  }

  # Read the userdata.tpl file
  user_data = templatefile("${path.module}/userdata.tpl", {
    db_name     = var.db_name,
    db_user     = var.db_user,
    db_password = var.db_password,
    db_endpoint = aws_db_instance.multi_az_mariadb.endpoint,
    domain_name = var.domain_name
  })
}