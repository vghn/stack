variable "email" {
  description = "Notifications email"
}

variable "travis_trusted_user_arn" {
  description = "Travis user ARN"
}

variable "vbot_trusted_user_arn" {
  description = "VBot user ARN"
}

variable "ursa_prometheus_role" {
  description = "The trusted role in the main account"
}

variable "puppet_secret" {
  description = "Puppet secret"
}

variable "puppetdb_user" {
  description = "PuppetDB user"
}

variable "puppetdb_pass" {
  description = "PuppetDB password"
}

variable "prometheus_backup_bucket" {
  description = "The Prometheus backup bucket"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = "map"
  default     = {}
}
