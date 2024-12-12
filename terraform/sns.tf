resource "aws_sns_topic" "topic" {
  name = "WebServer-CPU_Utilization_alert"
}

resource "aws_sns_topic_subscription" "topic_email_subscription" {
  count     = length(var.email_address)
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.email_address
}