output "orion_notifications_topic_arn" {
  sensitive   = true
  description = "The Orion notifications topic ARN"
  value       = "${module.orion.notifications_topic_arn}"
}

output "ursa_notifications_topic_arn" {
  sensitive   = true
  description = "The Ursa notifications topic ARN"
  value       = "${module.ursa.notifications_topic_arn}"
}

# PuppetDB
output "puppetdb_instance_address" {
  description = "The address of the PuppetDB RDS instance"
  value       = "${module.orion.puppetdb_instance_address}"
}

# Prometheus
output "prometheus_instance_public_ip" {
  description = "The IP address of the Prometheus instance"
  value       = "${module.orion.prometheus_instance_public_ip}"
}

output "prometheus_instance_public_dns" {
  description = "The DNS address of the Prometheus instance"
  value       = "${module.orion.prometheus_instance_public_dns}"
}

output "prometheus_efs_dns" {
  description = "The DNS of the Prometheus EFS"
  value       = "${module.orion.prometheus_efs_dns}"
}

output "mini_user_arn" {
  sensitive   = true
  description = "Mini user ARN"
  value       = "${module.ursa.mini_user_arn}"
}

output "mini_access_key_id" {
  sensitive   = true
  description = "Mini access key id"
  value       = "${module.ursa.mini_access_key_id}"
}

output "mini_secret_access_key" {
  sensitive   = true
  description = "Mini secret access key"
  value       = "${module.ursa.mini_secret_access_key}"
}

output "rhea_user_arn" {
  sensitive   = true
  description = "Rhea user ARN"
  value       = "${module.ursa.rhea_user_arn}"
}

output "rhea_access_key_id" {
  sensitive   = true
  description = "Rhea access key id"
  value       = "${module.ursa.rhea_access_key_id}"
}

output "rhea_secret_access_key" {
  sensitive   = true
  description = "Rhea secret access key"
  value       = "${module.ursa.rhea_secret_access_key}"
}

output "travis_user_arn" {
  sensitive   = true
  description = "Travis user ARN"
  value       = "${module.ursa.travis_user_arn}"
}

output "travis_access_key_id" {
  sensitive   = true
  description = "TravisCI access key id"
  value       = "${module.ursa.travis_access_key_id}"
}

output "travis_secret_access_key" {
  sensitive   = true
  description = "TravisCI secret access key"
  value       = "${module.ursa.travis_secret_access_key}"
}

output "travis_orion_role_arn" {
  sensitive   = true
  description = "The TravisCI role ARN on Orion"
  value       = "${module.orion.travis_role_arn}"
}

output "travis_orion_role_id" {
  sensitive   = true
  description = "The TravisCI role id on Orion"
  value       = "${module.orion.travis_role_id}"
}

output "zucu_user_arn" {
  sensitive   = true
  description = "Zucu user ARN"
  value       = "${module.ursa.zucu_user_arn}"
}

output "zucu_access_key_id" {
  sensitive   = true
  description = "Zucu access key id"
  value       = "${module.ursa.zucu_access_key_id}"
}

output "zucu_secret_access_key" {
  sensitive   = true
  description = "Zucu secret access key"
  value       = "${module.ursa.zucu_secret_access_key}"
}

output "vbot_user_arn" {
  sensitive   = true
  description = "VBot user ARN"
  value       = "${module.ursa.vbot_user_arn}"
}

# VBot
output "vbot_access_key_id" {
  sensitive   = true
  description = "VBot access key id"
  value       = "${module.ursa.vbot_access_key_id}"
}

output "vbot_secret_access_key" {
  sensitive   = true
  description = "VBot secret access key"
  value       = "${module.ursa.vbot_secret_access_key}"
}

output "vbot_role_arn" {
  sensitive   = true
  description = "VBot role ARN"
  value       = "${module.orion.vbot_role_arn}"
}

output "vbot_secrets_bucket" {
  sensitive   = true
  description = "The name of the secrets bucket for VBot"
  value       = "${module.orion.vbot_secrets_bucket}"
}
