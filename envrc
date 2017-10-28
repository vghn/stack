#!/usr/bin/env bash

# Bash strict mode
set -euo pipefail
IFS=$'\n\t'

# DEBUG
[ -z "${DEBUG:-}" ] || set -x

# VARs
DOCKER_PROJECT='vpm'
SSH_HOST='rhea.ghn.me'
SSH_USER='ubuntu'
SSH_KEY=$(mktemp 2>/dev/null || mktemp -t 'tmp')
ENCRYPT_KEY="${ENCRYPT_KEY:-$(echo "$TRAVIS_KEY_STACK" | base64)}"
PACKER_URL='https://releases.hashicorp.com/packer/1.1.1/packer_1.1.1_linux_amd64.zip'
export DOCKER_PROJECT SSH_HOST SSH_USER SSH_KEY ENCRYPT_KEY PACKER_URL

# System VARs
APPDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
TMPDIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'tmp')
NOW="$(date +"%Y%m%d_%H%M%S")"
VERSION=$(git describe --always --tags)
export APPDIR TMPDIR NOW VERSION

# Load private environment
# shellcheck disable=1090
. "${APPDIR}/.env" 2>/dev/null || true

# Load VGS library (https://github.com/vghn/vgs)
# shellcheck disable=1090
. ~/vgs/load || echo 'VGS library is required' 1>&2

# Load functions
if [[ -d "${APPDIR}/shlib" ]]; then
  # shellcheck disable=1090
  for file in ${APPDIR}/shlib/*.sh; do . "$file"; done
fi

# Detect environment
detect_environment 2>/dev/null || true
detect_ci_environment 2>/dev/null || true
ENVTYPE="${ENVTYPE:-production}"

# Project
export GROUP_NAME="${GROUP_NAME:-vgh}"
export PROJECT_NAME="${PROJECT_NAME:-vgh}"

# Trusted IPs
export TRUSTED_IPS="${TRUSTED_IPS:-}"

# Logging
export LOG_SERVER="${LOG_SERVER:-}"
export LOG_PORT="${LOG_PORT:-}"

# Slack Incoming Web Hook URL
export SLACK_CHANNEL="${SLACK_CHANNEL:-bots}"
export SLACK_USER="${SLACK_USER:-VGHStk}"
export SLACK_WEBHOOK="${SLACK_WEBHOOK:-}"

# AWS
export AWS_PROFILE="${AWS_PROFILE:-default}"
export AWS_ACCOUNT_NUMBER="${AWS_ACCOUNT_NUMBER:-}"
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"
export AWS_ASSETS_BUCKET="${AWS_ASSETS_BUCKET:-}"
export AWS_AZ_NUMBER="${AWS_AZ_NUMBER:-4}"
export AWS_SNS_NOTIFICATIONS="${AWS_SNS_NOTIFICATIONS:-"arn:aws:sns:${AWS_DEFAULT_REGION}:${AWS_ACCOUNT_NUMBER}:-NotifyMe"}"
export AWS_BUDGET="${AWS_BUDGET:-10}"
export AWS_LOG_RETENTION_DAYS="${AWS_LOG_RETENTION_DAYS:-14}"
export AWS_SSL_ARN="${AWS_SSL_ARN:-}"
export AWS_CFN_STACKS_PATH="${APPDIR}/cfn"
export AWS_IAM_INSTANCE_PROFILE="${AWS_IAM_INSTANCE_PROFILE:-}"
export AWS_AMI_PACKER="${APPDIR}/ami-packer.json"
export AWS_TAG_GROUP="${AWS_TAG_GROUP:-$GROUP_NAME}"
export AWS_TAG_PROJECT="${AWS_TAG_PROJECT:-$PROJECT_NAME}"
export AWS_RDS_DB_ENGINE="${AWS_RDS_DB_ENGINE:-mariadb}"
export AWS_RDS_DB_NAME="${AWS_RDS_DB_NAME:-db}"
export AWS_RDS_DB_USER="${AWS_RDS_DB_USER:-admin}"
export AWS_RDS_DB_PASS="${AWS_RDS_DB_PASS:-ChangeMe}"

# Puppet
export PP_SERVER="${PP_SERVER:-puppet.ghn.me}"
export PP_ARTIFACT="artifacts/vpm_${ENVTYPE}.tgz"
export PP_DB_ENGINE="${PP_DB_ENGINE:-postgres}"
export PP_DB_NAME="${PP_DB_NAME:-$AWS_RDS_DB_NAME}"
export PP_DB_USER="${PP_DB_USER:-$AWS_RDS_DB_USER}"
export PP_DB_PASS="${PP_DB_PASS:-$AWS_RDS_DB_PASS}"

# AWS Image defaults
ami_packer_process(){
  local V
  V="     -var 'base_ami=$(vgs_aws_ec2_get_ubuntu_base_image_id 'xenial-16.04')'"
  V="${V} -var 'iam_instance_profile=$(vgs_aws_cfn_get_output IAM InstanceProfile)'"
  export PACKER_VARS="${V}"
}

# Load AWS CloudFormation environment
# shellcheck disable=1090
. "${APPDIR}/cfnrc" 2>/dev/null || true
