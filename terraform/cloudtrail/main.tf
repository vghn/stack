resource "aws_cloudtrail" "cloudtrail" {
  name                          = "CloudTrail"
  s3_bucket_name                = "${aws_s3_bucket.cloudtrail.id}"
  include_global_service_events = true
  is_multi_region_trail         = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail.arn}"
  cloud_watch_logs_role_arn     = "${aws_iam_role.cloudtrail.arn}"

  tags = "${var.common_tags}"
}

resource "random_id" "cloudtrail" {
  byte_length = 8
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = "cloudtrail-${random_id.cloudtrail.hex}"
  policy = "${data.aws_iam_policy_document.cloudtrail_bucket.json}"

  tags = "${var.common_tags}"
}

data "aws_iam_policy_document" "cloudtrail_bucket" {
  statement {
    sid       = "AWSCloudTrailAclCheck"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::cloudtrail-${random_id.cloudtrail.hex}"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid       = "AWSCloudTrailWrite"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::cloudtrail-${random_id.cloudtrail.hex}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "CloudTrail"
  retention_in_days = "${var.log_retention}"

  tags = "${var.common_tags}"
}

resource "aws_iam_role" "cloudtrail" {
  name               = "cloudtrail"
  description        = "CloudTrail"
  assume_role_policy = "${data.aws_iam_policy_document.cloudtrail_assume_role.json}"
}

data "aws_iam_policy_document" "cloudtrail_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "cloudtrail" {
  role   = "${aws_iam_role.cloudtrail.id}"
  name   = "cloudtrail"
  policy = "${data.aws_iam_policy_document.cloudtrail_role.json}"
}

data "aws_iam_policy_document" "cloudtrail_role" {
  statement {
    sid       = "AWSCloudTrailCreateLogStream"
    actions   = ["logs:CreateLogStream"]
    resources = ["${aws_cloudwatch_log_group.cloudtrail.arn}"]
  }

  statement {
    sid       = "AWSCloudTrailPutLogEvents"
    actions   = ["logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.cloudtrail.arn}"]
  }
}
