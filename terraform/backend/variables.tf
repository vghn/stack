variable "env" {
  description = "Environment (Ex: production)"
}

variable "bucket" {
  description = "S3 bucket for the terraform state"
}

variable "bucket_name" {
  description = "'Name' tag for S3 bucket with the terraform state"
}

variable "dynamodb_table" {
  description = "DynamoDB table name for the terraform state lock"
}
