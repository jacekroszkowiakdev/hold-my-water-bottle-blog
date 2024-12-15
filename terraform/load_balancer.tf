# ALB Resource
resource "aws_lb" "wordpress_alb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.capstone_alb_sg.id]
  subnets            = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
  enable_cross_zone_load_balancing = true
  enable_deletion_protection = false

  tags = {
    Name = "Wordpress ALB"
  }
}

# Target Group
resource "aws_lb_target_group" "wordpress_tg" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.capstone_vpc.id

  target_type = "instance"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
        Name = "Wordpress target group"
    }
}

# Target Group Attachment
resource "aws_lb_target_group_attachment" "wordpress_tg_attachment" {
  target_group_arn = aws_lb_target_group.wordpress_tg.arn
  target_id        = aws_instance.wordpress_instance.id
  port             = 80
}

# Attach the ALB to the target group

resource "aws_autoscaling_attachment" "wordpress_alb_attachment" {
   autoscaling_group_name = aws_autoscaling_group.wordpress_asg.id
   lb_target_group_arn = aws_lb_target_group.wordpress_tg.arn
}

# HTTP Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

# HTTPS Listener - Sandbox IAM role restricts  acm:RequestCertificate :(
# resource "aws_lb_listener" "https_listener" {
#   load_balancer_arn = aws_lb.wordpress_alb.arn
#   port              = 443
#   protocol          = "HTTPS"

#   ssl_policy      = "ELBSecurityPolicy-2016-08"
#   certificate_arn = aws_acm_certificate.wordpress_ssl_cert.arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.wordpress_tg.arn
#   }
# }