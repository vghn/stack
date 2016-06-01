#!/usr/bin/env bash
# AWS EC2 image tasks

generate_user_data(){
  local file="${TMPDIR}/${FUNCNAME[0]}"
cat <<USERDATA > "$file"
#!/usr/bin/env bash
set -euo pipefail
IFS=\$'\\n\\t'

# Report status
echo 'IN_PROGRESS' | tee /var/lib/cloud/instance/status_ami

# VARs
export ENVTYPE=${ENVTYPE}
export PP_SERVER=puppet.ghn.me
export PP_ROLE=zeus
export PP_PROJECT=${PROJECT_NAME}
export PP_CERTNAME="\$(curl -s http://169.254.169.254/latest/meta-data/instance-id)"
export PP_RETRY_LOCAL=true
export PP_HIERADATA_URL='$(vgs_aws_s3_generate_presigned_url "$AWS_ASSETS_BUCKET" "$PP_HIERADATA_KEY" 300)'
export PP_GIT_BRANCH=${PP_GIT_BRANCH:-production}
export VGS_GIT_BRANCH=${VGS_GIT_BRANCH:-master}
export SLACK_WEBHOOK='${SLACK_WEBHOOK}'
export SLACK_CHANNEL=${SLACK_CHANNEL}
export SLACK_USER=${SLACK_USER}
export HOME=/root

echo 'Upgrade system'
apt-get -qy update < /dev/null
apt-get -qy dist-upgrade < /dev/null

echo 'Installing essential packages'
apt-get -qy install git < /dev/null

# Git branch
if [[ "\$ENVTYPE" == 'production' ]]; then
  export STK_GIT_BRANCH=master
else
  export STK_GIT_BRANCH="\$ENVTYPE"
fi

echo 'Get VGS library'
git clone -b "\$VGS_GIT_BRANCH" https://github.com/vghn/vgs.git /opt/vgs

echo 'Get puppet stack repo'
git clone -b "\$STK_GIT_BRANCH" https://github.com/vladgh/puppet_stk.git /opt/vpm/puppet_stk

echo 'Get puppet control repo'
git clone -b "\$PP_GIT_BRANCH" https://github.com/vladgh/puppet.git /opt/vpm/puppet

echo 'Bootstrap Puppet'
bash /opt/vpm/puppet/bootstrap

# Report status
echo 'SUCCEEDED' | tee /var/lib/cloud/instance/status_ami

echo 'Power Off AMI'
sleep 15; poweroff
USERDATA

  echo "$file"
}

create_instance(){
  e_info 'Creating EC2 instance'
  instance_id=$(vgs_aws_ec2_create_instance \
    "$AWS_EC2_KEY" \
    "$AWS_EC2_INSTANCE_TYPE" \
    "$(generate_user_data)")
  e_ok "  ... ${instance_id}"
}

tag_instance(){
  vgs_aws_ec2_create_tags "$instance_id" \
    Key=Group,Value="$AWS_TAG_GROUP" \
    Key=Name,Value="$AWS_EC2_IMAGE_PREFIX"
}

create_image(){
  e_info "Creating image from ${instance_id}"
  image_id=$(vgs_aws_ec2_image_create \
    "$instance_id" \
    "$AWS_EC2_IMAGE_PREFIX" \
    "$AWS_EC2_IMAGE_DESCRIPTION")
  e_ok "  ... ${image_id}"
}

tag_image(){
  vgs_aws_ec2_create_tags "$image_id" \
    Key=Group,Value="$AWS_TAG_GROUP" \
    Key=Name,Value="$AWS_EC2_IMAGE_PREFIX" \
    Key=Version,Value="$VERSION"
}

clean_up(){
  e_info 'Terminating instances'
  aws ec2 terminate-instances \
    --instance-ids "$instance_id" \
    --output text \
    --query 'TerminatingInstances[*].InstanceId'
  e_ok "  ... ${instance_id}"
}

ami_create(){
  create_instance && tag_instance
  e_info 'Waiting for instance to start'
  aws ec2 wait instance-running --instance-ids "$instance_id"
  e_info 'Waiting for instance to bootstrap and power off'
  aws ec2 wait instance-stopped --instance-ids "$instance_id" || \
    ( clean_up; e_abort 'Could not create image')

  create_image && tag_image
  e_info 'Waiting for image to be available'
  aws ec2 wait image-available --image-ids "$image_id" || clean_up

  clean_up
}
