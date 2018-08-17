output "topic_arn" {
  description = "The notifications topic ARN"
  value       = "${aws_cloudformation_stack.notifications.outputs["NotificationTopicArn"]}"
}
