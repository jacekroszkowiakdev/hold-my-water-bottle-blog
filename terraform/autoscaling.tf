resource "aws_launch_template" "wordpress_autoscaling_lt" {
  name          = "wordpress-lt"
  image_id      = data.aws_ami.amazon_linux2.id
  instance_type = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.capstone_blog_sg.id]
  key_name      = var.key_name

user_data = base64encode(
    templatefile("${path.module}/userdata.tpl", {
      db_name     = var.db_name,
      db_user     = var.db_user,
      db_password = var.db_password,
      db_endpoint = aws_db_instance.multi_az_mariadb.endpoint
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

resource "aws_autoscaling_group" "wordpress_instance_asg" {
  launch_template {
    id      = aws_launch_template.wordpress_autoscaling_lt.id
    version = "$Latest"
  }

  name                      = "wordpress-asg"
  min_size                  = 1
  max_size                  = 4
  desired_capacity          = 2

  vpc_zone_identifier = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  target_group_arns = [
    aws_lb_target_group.wordpress_tg.arn
  ]

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
    value               = "WordPress Blog Instance AS"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up-policy"
  policy_type = "TargetTrackingScaling"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name   = aws_autoscaling_group.wordpress_instance_asg.name

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
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name   = aws_autoscaling_group.wordpress_instance_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}
