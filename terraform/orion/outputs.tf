output "notifications_topic_arn" {
  description = "The notifications topic ARN"
  value       = "${module.notifications.topic_arn}"
}

# PuppetDB
output "puppetdb_instance_address" {
  description = "The address of the PuppetDB RDS instance"
  value       = "${module.puppetdb.this_db_instance_address}"
}

# Prometheus
output "prometheus_instance_public_ip" {
  description = "The IP address of the Prometheus instance"
  value       = "${aws_eip.prometheus.public_ip}"
}

output "prometheus_instance_public_dns" {
  description = "The DNS address of the Prometheus instance"
  value       = "${data.null_data_source.prometheus.outputs["public_dns"]}"
}

output "prometheus_role_arn" {
  description = "The Prometheus role ARN"
  value       = "${aws_iam_role.prometheus.arn}"
}

output "prometheus_role_id" {
  description = "The Prometheus role id"
  value       = "${aws_iam_role.prometheus.unique_id}"
}

output "prometheus_efs_dns" {
  description = "The DNS of the Prometheus EFS"
  value       = "${aws_efs_file_system.prometheus.dns_name}"
}

output "travis_role_arn" {
  description = "The TravisCI role ARN"
  value       = "${aws_iam_role.travis.arn}"
}

output "travis_role_id" {
  description = "The TravisCI role id"
  value       = "${aws_iam_role.travis.unique_id}"
}

# VBot
output "vbot_role_arn" {
  description = "The VBot role ARN"
  value       = "${aws_iam_role.vbot.arn}"
}

output "vbot_role_id" {
  description = "The VBot role id"
  value       = "${aws_iam_role.vbot.unique_id}"
}

output "vbot_secrets_bucket" {
  value = "${aws_s3_bucket.vbot_secrets.id}"
}
