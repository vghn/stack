resource "aws_s3_bucket" "vgast" {
  bucket = "vgast"
  acl    = "private"

  tags = "${var.common_tags}"
}

resource "aws_s3_bucket_policy" "vgast" {
  bucket = "${aws_s3_bucket.vgast.id}"
  policy = "${data.aws_iam_policy_document.vgast_bucket.json}"
}

data "aws_iam_policy_document" "vgast_bucket" {
  statement {
    sid       = "DenyUnEncryptedInflightOperations"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.vgast.arn}/*"]

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
