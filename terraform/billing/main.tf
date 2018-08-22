resource "aws_cloudwatch_metric_alarm" "billing" {
  count               = "${length(var.thresholds)}"
  alarm_name          = "Billing${count.index + 1}"
  alarm_description   = "Account Billing Alert for $$${var.thresholds[count.index]}"
  alarm_actions       = ["${var.notifications_topic_arn}"]
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "21600"
  statistic           = "Maximum"
  threshold           = "${var.thresholds[count.index]}"

  dimensions {
    Currency = "USD"
  }
}
