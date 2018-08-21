resource "aws_s3_bucket" "vgsec" {
  bucket = "vgsec"
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

resource "aws_s3_bucket_policy" "vgsec" {
  bucket = "${aws_s3_bucket.vgsec.id}"
  policy = "${data.aws_iam_policy_document.vgsec_bucket.json}"
}

data "aws_iam_policy_document" "vgsec_bucket" {
  statement {
    sid       = "DenyUnEncryptedInflightOperations"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.vgsec.id}/*"]

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
    resources = ["arn:aws:s3:::${aws_s3_bucket.vgsec.id}/*"]

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
    resources = ["arn:aws:s3:::${aws_s3_bucket.vgsec.id}/*"]

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
    sid     = "DenyEveryoneElse"
    effect  = "Deny"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.vgsec.id}",
      "arn:aws:s3:::${aws_s3_bucket.vgsec.id}/*",
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
      ]
    }
  }
}
