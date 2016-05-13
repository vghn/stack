#!/usr/bin/env bash
# AWS CloudFormation tasks

# Creates a new stack
cfn_create_stack(){
  e_info 'Creating stack'
  eval "aws cloudformation create-stack ${AWS_CFN_CMD_ARGS:?}"
}

# Update an existing stack
cfn_update_stack(){
  e_info 'Updating stack'
  eval "aws cloudformation update-stack ${AWS_CFN_CMD_ARGS:?}"
}

# Deletes an existing stack
cfn_delete_stack(){
  local name="${AWS_CFN_STACK_NAME:?}"
  e_warn "Deleting stack ${name}"
  eval "aws cloudformation delete-stack --stack-name ${name}"
}

# Validate stack
cfn_validate_stack(){
  local body="${1:-$AWS_CFN_STACK_BODY}"
  e_info "Validating ${body}"
  aws cloudformation validate-template \
    --output table \
    --template-body "file://${body}"
}

# Validate all stacks
cfn_validate_stacks(){
  for stack in ${AWS_CFN_STACKS_PATH:?}/*.json; do
    cfn_validate_stack "$stack"
  done
}

# Wait for stack to finish
cfn_wait_for_stack(){
  local name="${AWS_CFN_STACK_NAME:?}"
  if ! vgs_aws_cfn_wait "$name"; then
    e_abort "FATAL: The stack ${name} failed"
  fi
}

# Upload CloudFormation templates to S3
cfn_upload_templates(){
  local src="${AWS_CFN_STACKS_PATH:?}/"
  local dst="${AWS_CFN_STACKS_S3:?}/"
  if aws s3 sync "$src" "$dst" --delete; then
    e_info "Synced ${src} to ${dst}"
  else
    e_abort "Could not sync ${src} to ${dst}"
  fi
}

# Returns usage instructions if the stack name is not present
cfn_check_stack_name(){
  [[ -n "$CFN_STACK_ALIAS" ]] || usage
}

cfn_process_stacks(){
  local stack action
  stack=${1:-}
  action=${2:-}
  local ARGS P T

  case "$stack" in
    vgh)
      export AWS_CFN_STACK_NAME='VGH'
      export AWS_CFN_STACK_BODY="${AWS_CFN_STACKS_PATH}/vgh.json"
      if [[ "$action" == 'create' ]]; then
        ARGS='--disable-rollback --capabilities CAPABILITY_IAM'
      elif [[ "$action" == 'update' ]]; then
        ARGS='--capabilities CAPABILITY_IAM'
      else
        ARGS=''
      fi
      P="   ParameterKey=EnvType,ParameterValue=${ENVTYPE}"
      P="$P ParameterKey=KeyName,ParameterValue=${AWS_EC2_KEY}"
      P="$P ParameterKey=AssetsBucket,ParameterValue=${AWS_ASSETS_BUCKET}"
      P="$P ParameterKey=AssetsKeyPrefix,ParameterValue=${AWS_ASSETS_KEY_PREFIX}"
      P="$P ParameterKey=ProjectName,ParameterValue=${PROJECT_NAME}"
      P="$P ParameterKey=PuppetMaster,ParameterValue=${PUPPET_MASTER}"
      P="$P ParameterKey=CASSLS3Path,ParameterValue=${PP_VCRT_S3}"
      P="$P ParameterKey=HieraDataS3Path,ParameterValue=${PP_HIERADATA_S3}"
      P="$P ParameterKey=ZeusAMIId,ParameterValue=$(vgs_aws_ec2_get_latest_ami_id "$AWS_EC2_IMAGE_PREFIX")"
      P="$P ParameterKey=ZeusDesiredCapacity,ParameterValue=$(get_asg_desired_capacity)"
      P="$P ParameterKey=PuppetServerDesiredCount,ParameterValue=$(get_ecs_service_desired_running_count)"
      P="$P 'ParameterKey=SSHLocations,ParameterValue=\"${TRUSTED_IPS:-\"$(vgs_get_external_ip)/32\"}\"'"
      P="$P ParameterKey=DBEngine,ParameterValue=${AWS_RDS_DB_ENGINE}"
      P="$P ParameterKey=DBName,ParameterValue=${AWS_RDS_DB_NAME}"
      P="$P ParameterKey=DBUser,ParameterValue=${AWS_RDS_DB_USER}"
      P="$P ParameterKey=DBPassword,ParameterValue=${AWS_RDS_DB_PASS}"
      P="$P ParameterKey=SSLCertificateId,ParameterValue=${AWS_SSL_ARN}"
      P="$P ParameterKey=LogServer,ParameterValue=${LOG_SERVER}"
      P="$P ParameterKey=LogPort,ParameterValue=${LOG_PORT}"
      P="$P ParameterKey=VPCTemplateKey,ParameterValue=vpc.json"
      P="$P ParameterKey=SGTemplateKey,ParameterValue=sg.json"
      P="$P ParameterKey=IAMTemplateKey,ParameterValue=iam.json"
      P="$P ParameterKey=RDSTemplateKey,ParameterValue=rds.json"
      T="   Key=Group,Value=${AWS_TAG_GROUP}"
      export AWS_CFN_CMD_ARGS="--stack-name ${AWS_CFN_STACK_NAME} --template-body file://${AWS_CFN_STACK_BODY} ${ARGS} --parameters ${P} --tags ${T}"
      ;;
    *)
      ;;
  esac
}
