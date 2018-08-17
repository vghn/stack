module "backup_rhea" {
  source = "../backup"
  bucket = "vgbak-rhea"

  principals = [
    "${aws_iam_user.rhea.arn}",
  ]

  user_ids = [
    "${data.aws_caller_identity.ursa.account_id}",
    "${data.aws_iam_user.vlad.user_id}",
    "${aws_iam_user.rhea.unique_id}",
  ]
}

module "backup_prometheus" {
  source = "../backup"
  bucket = "vgbak-prometheus"

  principals = [
    "${var.prometheus_role_arn}",
  ]

  user_ids = [
    "${data.aws_caller_identity.ursa.account_id}",
    "${data.aws_iam_user.vlad.user_id}",
    "${var.prometheus_role_id}:*",
  ]
}

module "backup_mini" {
  source = "../backup"
  bucket = "vgbak-mini"

  principals = [
    "${aws_iam_user.mini.arn}",
  ]

  user_ids = [
    "${data.aws_caller_identity.ursa.account_id}",
    "${data.aws_iam_user.vlad.user_id}",
    "${aws_iam_user.mini.unique_id}",
  ]
}

module "backup_zucu" {
  source = "../backup"
  bucket = "vgbak-zucu"

  principals = [
    "${aws_iam_user.zucu.arn}",
  ]

  user_ids = [
    "${data.aws_caller_identity.ursa.account_id}",
    "${data.aws_iam_user.vlad.user_id}",
    "${aws_iam_user.zucu.unique_id}",
  ]
}

resource "aws_s3_bucket" "vgbak" {
  bucket = "vgbak"
  acl    = "private"

  tags {
    Group   = "vgh"
    Project = "vgh"
  }
}

resource "aws_s3_bucket_policy" "vgbak" {
  bucket = "${aws_s3_bucket.vgbak.id}"
  policy = "${data.aws_iam_policy_document.vgbak_secrets_bucket.json}"
}

data "aws_iam_policy_document" "vgbak_secrets_bucket" {
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
