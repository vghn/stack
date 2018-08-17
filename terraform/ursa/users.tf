resource "aws_iam_user" "mini" {
  name = "mini"
}

resource "aws_iam_access_key" "mini" {
  user = "${aws_iam_user.mini.name}"
}

resource "aws_iam_user" "zucu" {
  name = "zucu"
}

resource "aws_iam_access_key" "zucu" {
  user = "${aws_iam_user.zucu.name}"
}

resource "aws_iam_user" "rhea" {
  name = "rhea"
}

resource "aws_iam_user_policy" "rhea" {
  user   = "${aws_iam_user.rhea.id}"
  name   = "rhea"
  policy = "${data.aws_iam_policy_document.rhea_user.json}"
}

data "aws_iam_policy_document" "rhea_user" {
  statement {
    sid       = "AllowEC2Listing"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_access_key" "rhea" {
  user = "${aws_iam_user.rhea.name}"
}

resource "aws_iam_user" "travis" {
  name = "travis"
}

resource "aws_iam_user_policy_attachment" "administrator_access" {
  user       = "${aws_iam_user.travis.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "travis" {
  user = "${aws_iam_user.travis.name}"
}

resource "aws_iam_user" "vbot" {
  name = "vbot"
}

resource "aws_iam_user_policy" "vbot" {
  name   = "vbot"
  user   = "${aws_iam_user.vbot.name}"
  policy = "${data.aws_iam_policy_document.vbot_user.json}"
}

data "aws_iam_policy_document" "vbot_user" {
  statement {
    sid       = "AllowAssumeRole"
    actions   = ["sts:AssumeRole"]
    resources = ["${var.vbot_role_arn}"]
  }
}

resource "aws_iam_access_key" "vbot" {
  user = "${aws_iam_user.vbot.name}"
}
