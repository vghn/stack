variable "log_retention" {
  description = "The number of days log events are kept in CloudWatch Logs"
  default     = "14"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = "map"
  default     = {}
}
