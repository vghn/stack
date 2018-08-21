module "notifications" {
  source = "../notifications"
  email  = "${var.email}"

  common_tags = "${var.common_tags}"
}

module "billing" {
  source                  = "../billing"
  notifications_topic_arn = "${module.notifications.topic_arn}"
  thresholds              = ["1", "2", "3", "4", "5"]

  common_tags = "${var.common_tags}"
}

module "cloudtrail" {
  source = "../cloudtrail"

  common_tags = "${var.common_tags}"
}

data "aws_caller_identity" "ursa" {}

data "aws_iam_user" "vlad" {
  user_name = "vlad"
}

data "aws_iam_group" "Admins" {
  group_name = "Admins"
}
