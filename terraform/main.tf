terraform {
  backend "s3" {
    bucket         = "vgtf"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    acl            = "private"
    encrypt        = true
    dynamodb_table = "vgtf"
    profile        = "ursa"
  }
}

provider "aws" {
  version = "~> 1.28"
  profile = "ursa"
  region  = "us-east-1"
}

module "ursa" {
  source = "./ursa"

  email               = "${data.aws_ssm_parameter.email.value}"
  prometheus_role_arn = "${module.orion.prometheus_role_arn}"
  prometheus_role_id  = "${module.orion.prometheus_role_id}"
  vbot_role_arn       = "${module.orion.vbot_role_arn}"
}

provider "aws" {
  alias   = "orion"
  profile = "orion"
  region  = "us-east-1"
  version = "~> 1.28"
}

module "orion" {
  source = "./orion"

  providers = {
    aws = "aws.orion"
  }

  email                    = "${data.aws_ssm_parameter.email.value}"
  puppet_secret            = "${data.aws_ssm_parameter.puppet_secret.value}"
  puppetdb_user            = "${data.aws_ssm_parameter.puppetdb_user.value}"
  puppetdb_pass            = "${data.aws_ssm_parameter.puppetdb_pass.value}"
  travis_trusted_user_arn  = "${module.ursa.travis_user_arn}"
  vbot_trusted_user_arn    = "${module.ursa.vbot_user_arn}"
  ursa_prometheus_role     = "${module.ursa.prometheus_role_arn}"
  prometheus_backup_bucket = "${module.ursa.prometheus_backup_bucket}"
}

provider "cloudflare" {
  version = "~> 1.0"
  email   = "${data.aws_ssm_parameter.cf_email.value}"
  token   = "${data.aws_ssm_parameter.cf_token.value}"
}

provider "random" {
  version = "~> 1.3"
}
