# data "aws_ami" "amazon_linux2_test" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }
# }

# resource "aws_instance" "test_instance" {
#   ami                    = data.aws_ami.amazon_linux2.id
#   instance_type          = "t2.micro"
#   key_name               = "vockey"
#   subnet_id             = aws_subnet.public_subnet_2.id
#   associate_public_ip_address = true
#   vpc_security_group_ids = [aws_security_group.capstone_blog_sg.id]

#   tags = {
#     Name = "TEST Instance"
#   }

#   # Read the userData.sh file
#   user_data = file("../scripts/userDataEC2.sh")
# }