output "notifications_topic_arn" {
  description = "The notifications topic ARN"
  value       = "${module.notifications.topic_arn}"
}

output "mini_user_arn" {
  description = "Mini user ARN"
  value       = "${aws_iam_user.mini.arn}"
}

output "mini_access_key_id" {
  description = "Mini access key id"
  value       = "${aws_iam_access_key.mini_v1.id}"
}

output "mini_secret_access_key" {
  description = "Mini secret access key"
  value       = "${aws_iam_access_key.mini_v1.secret}"
}

output "rhea_user_arn" {
  description = "Rhea user ARN"
  value       = "${aws_iam_user.rhea.arn}"
}

output "rhea_access_key_id" {
  description = "Rhea access key id"
  value       = "${aws_iam_access_key.rhea_v1.id}"
}

output "rhea_secret_access_key" {
  description = "Rhea secret access key"
  value       = "${aws_iam_access_key.rhea_v1.secret}"
}

output "travis_user_arn" {
  description = "Travis user ARN"
  value       = "${aws_iam_user.travis.arn}"
}

output "travis_access_key_id" {
  description = "TravisCI access key id"
  value       = "${aws_iam_access_key.travis_v1.id}"
}

output "travis_secret_access_key" {
  description = "TravisCI secret access key"
  value       = "${aws_iam_access_key.travis_v1.secret}"
}

output "zucu_user_arn" {
  description = "Travis user ARN"
  value       = "${aws_iam_user.zucu.arn}"
}

output "zucu_access_key_id" {
  description = "Zucu access key id"
  value       = "${aws_iam_access_key.zucu_v1.id}"
}

output "zucu_secret_access_key" {
  description = "Zucu secret access key"
  value       = "${aws_iam_access_key.zucu_v1.secret}"
}

# VBot
output "vbot_user_arn" {
  description = "VBot user ARN"
  value       = "${aws_iam_user.vbot.arn}"
}

output "vbot_access_key_id" {
  description = "VBot access key id"
  value       = "${aws_iam_access_key.vbot_v1.id}"
}

output "vbot_secret_access_key" {
  description = "VBot secret access key"
  value       = "${aws_iam_access_key.vbot_v1.secret}"
}

output "prometheus_role_arn" {
  description = "Promethesu role ARN"
  value       = "${aws_iam_role.prometheus.arn}"
}

output "prometheus_backup_bucket" {
  description = "The name of the backup bucket for Prometheus"
  value       = "${module.backup_prometheus.bucket}"
}
