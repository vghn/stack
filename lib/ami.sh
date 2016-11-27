#!/usr/bin/env bash
# AWS EC2 image tasks

# USAGE
ami_usage(){
  e_error "USAGE: ami [COMMAND]"
  e_error "COMMANDS: create | clean | validate"
  e_abort 'Please consult the README'
}

# Process AMI script arguments
ami_process(){
  case "${1:-}" in
    create)
      ami_create
      ;;
    clean)
      ami_clean
      ;;
    validate)
      ami_validate
      ;;
    *)
      ami_usage
      ;;
  esac
}

ami_validate(){
  ami_packer_process
  e_info "Validate ${AWS_AMI_PACKER}"
  eval packer validate "${PACKER_VARS}" "$AWS_AMI_PACKER"
}

ami_create(){
  ami_packer_process
  eval packer build "${PACKER_VARS}" "$AWS_AMI_PACKER"
}

# Removes images and snapshots for a given image prefix as well as the
# the ones that are currently used in launch configurations inside a stack
ami_clean(){
  vgs_aws_ec2_images_purge "VGH_RHEA_*" "'$(vgs_aws_cfn_get_parameter RHEA ImageID)'"
}
