variable "notifications_topic_arn" {
  description = "The ARN of the notifications topic"
}

variable "thresholds" {
  description = "Numerical Thresholds - in $USD - for Billing alarms. Enter five (5) values for the billing alarms (e.g., 1,5,10,20,50)"
  type        = "list"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = "map"
  default     = {}
}

variable "account" {
  description = "The account name"
  default     = "Main"
}
