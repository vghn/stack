resource "aws_cloudformation_stack" "notifications" {
  name = "notifications"

  tags = "${var.common_tags}"

  parameters {
    NotificationEmail = "${var.email}"
  }

  template_body = <<STACK
Description: VGH Notifications

Parameters:
  NotificationEmail:
    Description: The email used for notifications
    Type: String

Resources:
  NotificationTopic:
    Type: AWS::SNS::Topic
    Properties:
      TopicName: NotifyMe
      DisplayName: VGH Notifications
      Subscription:
      - Endpoint: !Ref NotificationEmail
        Protocol: email

Outputs:
  NotificationTopicArn:
    Description: The Notification topic ARN
    Value: !Ref NotificationTopic
    Export:
      Name: NotificationsARN
STACK
}
