module "backup_rhea" {
  source = "../modules/backup"
  bucket = "vgbak-rhea"

  principals = [
    "${aws_iam_user.rhea.arn}",
  ]

  user_ids = [
    "${data.aws_caller_identity.ursa.account_id}",
    "${data.aws_iam_user.vlad.user_id}",
    "${aws_iam_user.travis.unique_id}",
    "${aws_iam_user.rhea.unique_id}",
  ]

  common_tags = "${var.common_tags}"
}

module "backup_prometheus" {
  source = "../modules/backup"
  bucket = "vgbak-prometheus"

  principals = [
    "${var.prometheus_role_arn}",
  ]

  user_ids = [
    "${data.aws_caller_identity.ursa.account_id}",
    "${data.aws_iam_user.vlad.user_id}",
    "${aws_iam_user.travis.unique_id}",
    "${var.prometheus_role_id}:*",
  ]

  common_tags = "${var.common_tags}"
}

module "backup_mini" {
  source = "../modules/backup"
  bucket = "vgbak-mini"

  principals = [
    "${aws_iam_user.mini.arn}",
  ]

  user_ids = [
    "${data.aws_caller_identity.ursa.account_id}",
    "${data.aws_iam_user.vlad.user_id}",
    "${aws_iam_user.travis.unique_id}",
    "${aws_iam_user.mini.unique_id}",
  ]

  common_tags = "${var.common_tags}"
}

module "backup_zucu" {
  source = "../modules/backup"
  bucket = "vgbak-zucu"

  principals = [
    "${aws_iam_user.zucu.arn}",
  ]

  user_ids = [
    "${data.aws_caller_identity.ursa.account_id}",
    "${data.aws_iam_user.vlad.user_id}",
    "${aws_iam_user.travis.unique_id}",
    "${aws_iam_user.zucu.unique_id}",
  ]

  common_tags = "${var.common_tags}"
}

resource "aws_s3_bucket" "vgbak" {
  bucket = "vgbak"
  acl    = "private"
  tags   = "${var.common_tags}"
}

resource "aws_s3_bucket_policy" "vgbak" {
  bucket = "${aws_s3_bucket.vgbak.id}"
  policy = "${data.aws_iam_policy_document.vgbak_bucket.json}"
}

data "aws_iam_policy_document" "vgbak_bucket" {
  statement {
    sid       = "DenyUnEncryptedInflightOperations"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.vgbak.id}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = [false]
    }
  }
}
