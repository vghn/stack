resource "aws_s3_bucket" "vgbak" {
  bucket = "${var.bucket}"
  acl    = "private"

  lifecycle_rule {
    id      = "Hourly Rotation"
    prefix  = "hourly/"
    enabled = true

    expiration {
      days = "1"
    }
  }

  lifecycle_rule {
    id      = "Daily Rotation"
    prefix  = "daily/"
    enabled = true

    expiration {
      days = "7"
    }
  }

  lifecycle_rule {
    id      = "Weekly Rotation"
    prefix  = "weekly/"
    enabled = true

    expiration {
      days = "30"
    }
  }

  tags = "${var.common_tags}"
}

resource "aws_s3_bucket_policy" "vgbak" {
  bucket = "${aws_s3_bucket.vgbak.id}"
  policy = "${data.aws_iam_policy_document.vgbak.json}"
}

# Policy based on https://aws.amazon.com/blogs/security/how-to-restrict-amazon-s3-bucket-access-to-a-specific-iam-role/
data "aws_iam_policy_document" "vgbak" {
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

  statement {
    sid       = "AllowListing"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.vgbak.id}"]

    principals {
      type        = "AWS"
      identifiers = ["${var.principals}"]
    }
  }

  statement {
    sid = "AllowUserAccess"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = ["arn:aws:s3:::${aws_s3_bucket.vgbak.id}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${var.principals}"]
    }
  }

  statement {
    sid     = "DenyEveryoneElse"
    effect  = "Deny"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.vgbak.id}",
      "arn:aws:s3:::${aws_s3_bucket.vgbak.id}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotLike"
      variable = "aws:userId"
      values   = ["${var.user_ids}"]
    }
  }
}
