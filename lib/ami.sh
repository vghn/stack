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
export PP_ROLE=zeus
export PP_SERVER=puppet.ghn.me
export PP_HIERADATA_S3=${PP_HIERADATA_S3}
export PP_PROJECT=${PROJECT_NAME}
export PP_CERTNAME="\$(curl -s http://169.254.169.254/latest/meta-data/instance-id)"
export ENVTYPE=${ENVTYPE}
export SLACK_WEBHOOK=${SLACK_WEBHOOK}
export SLACK_CHANNEL=${SLACK_CHANNEL}
export SLACK_USER=${SLACK_USER}
export HOME=/root
export BUILD_DIR="${TMPDIR}/ami_build"

echo 'Upgrade system'
apt-get -qy update < /dev/null
apt-get -qy dist-upgrade < /dev/null

if ! command -v wget >/dev/null 2>&1; then
  echo 'Installing WGet'
  apt-get -qy install wget < /dev/null
fi

if ! command -v git >/dev/null 2>&1; then
  echo 'Installing Git'
  apt-get -qy install git < /dev/null
fi

if ! command -v pip >/dev/null 2>&1; then
  echo 'Installing pip'
  apt-get -qy install python-pip < /dev/null
fi

echo 'Adding swap space'
SWAP=/var/swap.space
/bin/dd if=/dev/zero of=\${SWAP} bs=1M count=1024
/sbin/mkswap \${SWAP} && /sbin/swapon \${SWAP}
echo "\${SWAP}  swap  swap  defaults  0  0" >> /etc/fstab

# Fix for Ubuntu Trusty
# https://urllib3.readthedocs.io/en/latest/security.html#insecureplatformwarning
echo 'Upgrade python https'
apt-get -qy install python-dev libffi-dev libssl-dev < /dev/null
pip install --upgrade ndg-httpsclient

echo 'Installing AWS CLI'
pip install --upgrade pip setuptools awscli

echo 'Installing VGS library'
mkdir -p /opt/vgs && wget -qO- https://s3.amazonaws.com/vghn/vgs.tgz | \
  tar xz --no-same-owner -C /opt/vgs

echo 'Get puppet control repo'
git clone https://github.com/vladgh/puppet.git "\$BUILD_DIR"

echo 'Bootstrap Puppet'
bash "\${BUILD_DIR}/bootstrap"

# Report status
echo 'SUCCEEDED' | tee /var/lib/cloud/instance/status_ami

echo 'Power Off AMI'
sleep 10; poweroff
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
