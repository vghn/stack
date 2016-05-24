#!/usr/bin/env bash
# Clean-up tasks

# Purge old S3 keys (keep the 5 most recent)
aws_s3_purge_deployments(){
  for key in $(vgs_aws_s3_list_old_keys "$AWS_ASSETS_BUCKET" "${AWS_ASSETS_KEY_PREFIX}/app/${PROJECT_NAME}-" "$KEEP"); do
    aws s3api delete-object \
      --bucket "$AWS_ASSETS_BUCKET" \
      --key "$key"
    e_info "$key deleted"
  done
}

# Removes images and snapshots for a given image prefix as well as the
# the ones that are currently used in launch configurations inside a stack
ami_clean(){
  vgs_aws_ec2_images_purge "${AWS_EC2_IMAGE_PREFIX}_*" "'$(vgh_aws_cfn_list_images_in_use "$AWS_CFN_STACK_NAME")'"
}
