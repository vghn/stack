module "notifications" {
  source = "../notifications"
  email  = "${var.email}"
}

module "billing" {
  source                  = "../billing"
  notifications_topic_arn = "${module.notifications.topic_arn}"
  thresholds              = ["1", "2", "3", "4", "5"]
}

module "cloudtrail" {
  source = "../cloudtrail"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.37.0"

  name = "VGH"
  cidr = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  azs            = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]

  tags {
    Group   = "vgh"
    Project = "vgh"
  }
}

data "aws_caller_identity" "orion" {}

data "aws_iam_role" "vlad" {
  name = "vlad"
}