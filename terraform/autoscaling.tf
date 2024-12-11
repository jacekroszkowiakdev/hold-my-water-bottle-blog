resource "aws_launch_configuration" "wordpress_autoscaling_lc" {
    name          = "wordpress-lc"
    image_id        = data.aws_ami.amazon_linux2.id
    instance_type   = var.ec2_instance_type
    security_groups = [aws_security_group.capstone_blog_sg.id]
    key_name        = var.key_name

    depends_on = [ aws_instance.wordpress_instance ]

    user_data = templatefile("${path.module}/userdata.tpl", {
    db_name     = var.db_name,
    db_user     = var.db_user,
    db_password = var.db_password,
    db_endpoint = aws_db_instance.multi_az_mariadb.endpoint
    })

    lifecycle {
        create_before_destroy = true
    }
}

# You must specify either launch_configuration, launch_template, or mixed_instances_policy.

resource "aws_autoscaling_group" "wordpress_instance_asg" {
    launch_configuration = aws_launch_configuration.wordpress_autoscaling_lc.id
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

  lifecycle {
    create_before_destroy = true
  }

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }

  timeouts {
    delete = "15m"
  }

  termination_policies = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "wordpress-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress_instance_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress_instance_asg.name
}