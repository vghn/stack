# Admins Group
resource "aws_iam_group" "on_premise" {
  name = "OnPremise"
}

resource "aws_iam_group_policy_attachment" "s3_full_access" {
  group      = "${aws_iam_group.on_premise.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy" "on_premise" {
  group  = "${aws_iam_group.on_premise.id}"
  name   = "on_premise"
  policy = "${data.aws_iam_policy_document.on_premise_group.json}"
}

data "aws_iam_policy_document" "on_premise_group" {
  statement {
    sid       = "AllowListingParameters"
    actions   = ["ssm:DescribeParameters"]
    resources = ["*"]
  }

  statement {
    sid       = "AllowGettingParameters"
    actions   = ["ssm:Get*"]
    resources = ["arn:aws:ssm:*:*:parameter/&{aws:username}/*"]
  }
}

resource "aws_iam_group_membership" "on_premise" {
  name  = "on_premise"
  group = "${aws_iam_group.on_premise.name}"

  users = [
    "${aws_iam_user.mini.name}",
    "${aws_iam_user.rhea.name}",
    "${aws_iam_user.zucu.name}",
  ]
}
