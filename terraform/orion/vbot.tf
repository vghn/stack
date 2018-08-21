# VBot Role
resource "aws_iam_role" "vbot" {
  name               = "vbot"
  description        = "VBot Administrator"
  assume_role_policy = "${data.aws_iam_policy_document.vbot_assume_role.json}"
}

data "aws_iam_policy_document" "vbot_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${var.vbot_trusted_user_arn}"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "vbot" {
  role       = "${aws_iam_role.vbot.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# VBot Secrets S3 Bucket
resource "aws_s3_bucket" "vbot_secrets" {
  bucket = "vbot-secrets"
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

# VBot Secrets S3 Bucket Policy
resource "aws_s3_bucket_policy" "vbot_secrets" {
  bucket = "${aws_s3_bucket.vbot_secrets.id}"
  policy = "${data.aws_iam_policy_document.vbot_secrets_bucket.json}"
}

data "aws_iam_policy_document" "vbot_secrets_bucket" {
  statement {
    sid       = "DenyUnEncryptedInflightOperations"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.vbot_secrets.id}/*"]

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
    resources = ["arn:aws:s3:::${aws_s3_bucket.vbot_secrets.id}/*"]

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
    resources = ["arn:aws:s3:::${aws_s3_bucket.vbot_secrets.id}/*"]

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
    resources = ["arn:aws:s3:::${aws_s3_bucket.vbot_secrets.id}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_role.vbot.arn}"]
    }
  }

  statement {
    sid       = "AlowReadOnlyAccesstoSecrets"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.vbot_secrets.id}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_role.vbot.arn}"]
    }
  }
}
