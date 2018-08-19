# Terraform State

Terraform module to create the S3/DynamoDB backend to store the Terraform state and lock.
The state created by this tf should be stored in source control.

## Usage

Configure your AWS credentials.

```sh
export AWS_ACCESS_KEY_ID='ABCDEF'
export AWS_SECRET_ACCESS_KEY='ABCDEF'
export AWS_DEFAULT_REGION='us-east-1'
```

This should be used in a dedicated terraform workspace or environment. The
resulting `terraform.tfstate` should be stored in source control. As long as
you configured AWS credentials as above (not in the provider), then no secrets
will be stored in source control as part of your state.

```sh
terraform apply \
  -var 'env=production' \
  -var 'bucket=vgtf' \
  -var 'table=vgtf'
```

You can now configure your Terraform environments to use this backend:

```hcl
terraform {
    backend "s3" {
    bucket         = "vgtf"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    acl            = "private"
    encrypt        = true
    dynamodb_table = "vgtf"
    }
}
```
