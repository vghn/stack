resource "aws_iam_role" "prometheus" {
  name               = "prometheus"
  description        = "Prometheus"
  assume_role_policy = "${data.aws_iam_policy_document.prometheus_assume_role.json}"
}

data "aws_iam_policy_document" "prometheus_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "prometheus" {
  name   = "prometheus"
  role   = "${aws_iam_role.prometheus.name}"
  policy = "${data.aws_iam_policy_document.prometheus_role.json}"
}

data "aws_iam_policy_document" "prometheus_role" {
  statement {
    sid       = "AllowAssumeRole"
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
  }

  statement {
    sid = "AllowScalingOperations"

    actions = [
      "ec2:Describe*",
      "autoscaling:Describe*",
      "autoscaling:EnterStandby",
      "autoscaling:ExitStandby",
      "elasticloadbalancing:ConfigureHealthCheck",
      "elasticloadbalancing:DescribeLoadBalancers",
    ]

    resources = ["*"]
  }

  statement {
    sid = "AllowLogging"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    sid       = "AllowS3ListAllBuckets"
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
  }

  statement {
    sid     = "AllowS3AccessToAssetsBucket"
    actions = ["*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.prometheus.id}",
      "arn:aws:s3:::${aws_s3_bucket.prometheus.id}/*",
    ]
  }

  statement {
    sid     = "AllowS3AccessToBackupBucket"
    actions = ["*"]

    resources = [
      "arn:aws:s3:::${var.prometheus_backup_bucket}",
      "arn:aws:s3:::${var.prometheus_backup_bucket}/*",
    ]
  }

  # Grafana
  statement {
    sid = "AllowReadingMetricsFromCloudWatch"

    actions = [
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricStatistics",
    ]

    resources = ["*"]
  }

  statement {
    sid = "AllowReadingTagsFromEC2"

    actions = [
      "ec2:DescribeTags",
      "ec2:DescribeInstances",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "travis" {
  name               = "travis"
  description        = "TravisCI"
  assume_role_policy = "${data.aws_iam_policy_document.travis_assume_role.json}"
}

data "aws_iam_policy_document" "travis_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${var.travis_trusted_user_arn}"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "administrator_access" {
  role       = "${aws_iam_role.travis.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
