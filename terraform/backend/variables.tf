variable "env" {
  description = "Environment (Ex: production)"
}

variable "bucket" {
  description = "S3 bucket for the terraform state"
}

variable "table" {
  description = "DynamoDB table name for the terraform state lock"
}
