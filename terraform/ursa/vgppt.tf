resource "aws_s3_bucket" "vgppt" {
  bucket = "vgppt"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = "${var.common_tags}"
}

resource "aws_s3_bucket_policy" "vgppt" {
  bucket = "${aws_s3_bucket.vgppt.id}"
  policy = "${data.aws_iam_policy_document.vgppt_bucket.json}"
}

data "aws_iam_policy_document" "vgppt_bucket" {
  statement {
    sid       = "DenyUnEncryptedInflightOperations"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.vgppt.id}/*"]

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
    sid       = "DenyUnEncryptedObjectUploads"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.vgppt.id}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }
  }

  statement {
    sid       = "DenyIncorrectEncryptionHeader"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.vgppt.id}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256", "aws:kms"]
    }
  }

  statement {
    sid       = "AllowListing"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.vgppt.id}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_user.rhea.arn}"]
    }
  }

  statement {
    sid = "AllowRhea"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = ["arn:aws:s3:::${aws_s3_bucket.vgppt.id}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_user.rhea.arn}"]
    }
  }

  statement {
    sid     = "DenyEveryoneElse"
    effect  = "Deny"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.vgppt.id}",
      "arn:aws:s3:::${aws_s3_bucket.vgppt.id}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotLike"
      variable = "aws:userId"

      values = [
        "${data.aws_caller_identity.ursa.account_id}",
        "${data.aws_iam_user.vlad.user_id}",
        "${aws_iam_user.travis.unique_id}",
        "${aws_iam_user.rhea.unique_id}",
      ]
    }
  }
}
