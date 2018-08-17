# Notifications
data "aws_ssm_parameter" "email" {
  name = "/vgh/email"
}

# CloudFlare
data "aws_ssm_parameter" "cf_email" {
  name = "/cloudflare/email"
}

data "aws_ssm_parameter" "cf_token" {
  name = "/cloudflare/token"
}

# Puppet
data "aws_ssm_parameter" "puppetdb_user" {
  name = "/puppet/db/user"
}

data "aws_ssm_parameter" "puppetdb_pass" {
  name = "/puppet/db/pass"
}

data "aws_ssm_parameter" "puppet_secret" {
  name = "/puppet/vgh/secret"
}
