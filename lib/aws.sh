#!/usr/bin/env bash
# AWS tasks

# Ensure AWSCLI
ensure_awscli(){
  if ! command -v aws >/dev/null 2>&1; then
    echo 'Ensure latest Python PIP and AWS-CLI'
    pip install --user --upgrade pip awscli
  fi
}

# Returns the desired capacity for the specified AutoScaling Group
get_asg_desired_capacity(){
  local asg count
  asg="$(vgs_aws_cfn_get_output VGH ZeusASGName)"
  count="$(aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-names "$asg" \
    --query "AutoScalingGroups[0].DesiredCapacity" \
    --output text || true)"
  [[ "$count" =~ ^[0-9]+$ ]] && echo "$count" || echo 0
}

# Returns the desired running count for the specified ECS Service
get_ecs_service_desired_running_count(){
  local cluster service count
  cluster="$(vgs_aws_cfn_get_output VGH ECSCluster)"
  service="$(vgs_aws_cfn_get_output VGH ECSService)"
  count="$(aws ecs describe-services \
    --cluster "$cluster" \
    --services "$service" \
    --query "services[0].runningCount" \
    --output text || true)"
  [[ "$count" =~ ^[0-9]+$ ]] && echo "$count" || echo 0
}
