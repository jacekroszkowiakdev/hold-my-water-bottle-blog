resource "aws_cloudwatch_metric" "cpu_utilization" {
  namespace = "AWS/EC2"
  metric_name = "CPUUtilization"
  dimensions = {
    InstanceId = aws_autoscaling_group.wordpress_instance_asg.instance_ids[0]
  }
}

resource "aws_cloudwatch_alarm" "scale_up_alarm" {
  alarm_name = "wordpress_asg_scale_up"
  alarm_description = "Scale up ASG when CPU exceeds 80%"
  alarm_type = "scaling"
  statistic = "Average"
  period = 300
  evaluation_periods = 2
  threshold = 80.0
  comparison_operator = "GreaterThanThreshold"
  namespace = aws_cloudwatch_metric.cpu_utilization.namespace
  metric_name = aws_cloudwatch_metric.cpu_utilization.metric_name
  dimensions = aws_cloudwatch_metric.cpu_utilization.dimensions

  scaling_policy = aws_autoscaling_policy.scale_up.name
}

resource "aws_cloudwatch_alarm" "scale_down_alarm" {
  alarm_name          = "wordpress_asg_scale_down"
  alarm_description   = "Scale down ASG when CPU is below 20%"
  alarm_type          = "scaling"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 20.0
  comparison_operator = "LessThanThreshold"
  namespace           = aws_cloudwatch_metric.cpu_utilization.namespace
  metric_name         = aws_cloudwatch_metric.cpu_utilization.metric_name
  dimensions          = aws_cloudwatch_metric.cpu_utilization.dimensions

  scaling_policy      = aws_autoscaling_policy.scale_down.name
}