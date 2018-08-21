variable "bucket" {
  description = "The name of the backup bucket"
}

variable "principals" {
  description = "The ARN of users/roles that have access to the bucket"
  type        = "list"
}

variable "user_ids" {
  description = "The user ids of users/roles that have access to the bucket (Note: for assumed roles the ID needs to end with  `:*`)"
  type        = "list"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = "map"
  default     = {}
}
