variable "email" {
  description = "Notifications email"
}

variable "prometheus_role_arn" {
  description = "Prometheus role ARN"
}

variable "prometheus_role_id" {
  description = "Prometheus role id"
}

variable "vbot_role_arn" {
  description = "VBot role ARN"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = "map"
  default     = {}
}
