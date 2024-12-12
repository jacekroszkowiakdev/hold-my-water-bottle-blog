resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  alarm_name                = "wordpress_asg_CPU_80%"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 cpu utilization"
  dimensions = {
    InstanceId = aws_instance.wordpress_instance.id
  }

  #alarm_actions       = [aws_sns_topic.sns_topic.arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name = "wordpress_asg_scale_up"
  alarm_description = "Scale up ASG when CPU exceeds 85%"
  comparison_operator       = "GreaterThanThreshold"
  statistic = "Average"
  evaluation_periods = 2
  threshold = 85.0
  namespace = "AWS/EC2"
  metric_name               = "CPUUtilization"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_instance_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
  #alarm_actions       = [aws_sns_topic.sns_topic.arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "wordpress_asg_scale_down"
  alarm_description   = "Scale down ASG when CPU is below 50%"
  comparison_operator = "LessThanThreshold"
  statistic           = "Average"
  evaluation_periods  = 2
  threshold           = 50.0
  namespace = "AWS/EC2"
  metric_name         = "CPUUtilization"
   dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_instance_asg.name
  }
  alarm_actions      = [aws_autoscaling_policy.scale_down.arn]
  #alarm_actions       = [aws_sns_topic.sns_topic.arn]
}