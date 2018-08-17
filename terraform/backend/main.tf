# Terraform module for managing the S3 bucket and DynamoDB table for
# the terraform state store.

# The default AWS provider configuration
provider "aws" {
  version = "~> 1.28"
}

resource "aws_s3_bucket" "terraform" {
  bucket = "${var.bucket}"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    Name        = "${var.bucket_name}"
    Environment = "${var.env}"
  }
}

resource "aws_dynamodb_table" "terraform" {
  name           = "${var.dynamodb_table}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  server_side_encryption = {
    "enabled" = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}
