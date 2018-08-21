variable "email" {
  description = "The email address used for notifications"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = "map"
  default     = {}
}
