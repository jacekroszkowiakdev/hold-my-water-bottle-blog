resource "aws_launch_template" "wordpress_autoscaling_lt" {
  name          = "wordpress-lt"
  image_id      = data.aws_ami.amazon_linux2.id
  instance_type = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.capstone_wordpress_sg.id]
  key_name      = var.key_name

user_data = base64encode(
    templatefile("${path.module}/userdata.tpl", {
      db_name     = var.db_name,
      db_user     = var.db_user,
      db_password = var.db_password,
      db_endpoint = aws_db_instance.multi_az_mariadb.endpoint,
      domain_name = var.domain_name
    })
  )

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "wordpress-instance"
    }
  }
}

resource "aws_autoscaling_group" "wordpress_asg" {
  launch_template {
    id      = aws_launch_template.wordpress_autoscaling_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  target_group_arns = [
    aws_lb_target_group.wordpress_tg.arn
  ]

  name                      = "wordpress-asg"
  min_size                  = 1
  max_size                  = 4
  desired_capacity          = 2

  health_check_type         = "ELB"
  health_check_grace_period = 300

  termination_policies = ["OldestInstance"]

  lifecycle {
    create_before_destroy = true
  }

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 100
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Name"
    value               = "WordPress Instance AS"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up-policy"
  policy_type = "TargetTrackingScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name   = aws_autoscaling_group.wordpress_asg.name

    target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 85.0
  }
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down-policy"
  policy_type = "TargetTrackingScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name   = aws_autoscaling_group.wordpress_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

resource "aws_autoscaling_attachment" "wordpress_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
  lb_target_group_arn = aws_lb_target_group.wordpress_tg.arn
}
