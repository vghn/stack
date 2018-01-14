#!/usr/bin/env bash
# Common functions

ami_validate(){
  e_info "Validate ${AWS_AMI_PACKER}"
  eval packer validate "${PACKER_VARS}" "$AWS_AMI_PACKER"
}

ami_create(){
  eval packer build "${PACKER_VARS}" "$AWS_AMI_PACKER"
}

# Removes images and snapshots for a given image prefix as well as the
# the ones that are currently used in launch configurations inside a stack
ami_clean(){
  vgs_aws_ec2_images_purge "VGH_RHEA_*" "'$(vgs_aws_cfn_get_parameter RHEA ImageID)'"
}

# Creates a new stack
cfn_create_stack(){
  e_info 'Creating stack'
  eval "aws cloudformation create-stack ${cfn_cmd:-}"
}

# Update an existing stack
cfn_update_stack(){
  e_info 'Updating stack'
  eval "aws cloudformation update-stack ${cfn_cmd:-}"
}

# Deletes an existing stack
cfn_delete_stack(){
  e_warn "Deleting stack ${name:-}"
  eval "aws cloudformation delete-stack --stack-name ${name:-}"
}

# Validate stack
cfn_validate_stack(){
  e_info "Validating ${body:-}"
  aws cloudformation validate-template \
    --output table \
    --template-body "file://${AWS_CFN_STACKS_PATH}/${body:-}"
}

# Wait for stack to finish
cfn_wait_for_stack(){
  if ! vgs_aws_cfn_wait "${name:-}"; then
    e_abort "FATAL: The stack ${name:-} failed"
  fi
}

# Install and load the VGS library (https://github.com/vghn/vgs)
install_vgs(){
  if [[ ! -d ~/vgs ]]; then
    echo 'Install and load VGS library'
    git clone https://github.com/vghn/vgs.git ~/vgs
  fi
  # Load VGS library (https://github.com/vghn/vgs)
  # shellcheck disable=1090
  . ~/vgs/load || echo 'VGS library is required' 1>&2
}

# Install gems
install_gems(){
  echo 'Install gems'
  bundle install --without development --path vendor/bundle
}

# Install AWS Command Line
install_aws_cli(){
  echo 'Install AWS-CLI'
  pip install --user --upgrade awscli
}

# Install HashiCorp Packer
install_packer(){
  echo 'Install HashiCorp Packer'
  curl -L -o packer.zip "$PACKER_URL"
  unzip -d ~/bin packer.zip
}

# Validate BASH scripts
validate_bash(){
  e_info 'Validate BASH scripts'
  find ./bin -type f -exec shellcheck {} +
}

# Validate CloudFormation templates
validate_cfn(){
  e_info 'Validate CloudFormation templates'
  find ./cfn \( -name '*.yaml' -o -name '*.json' \) -exec sh -c \
    'echo "Checking ${1}" && aws cloudformation validate-template --template-body "file://${1}" --output table' \
    -- {} \;
}

# Validate AMIs
validate_amis(){
  e_info 'Validate AMIs'
  eval "${APPDIR}/bin/ami" validate
}

# Set-up SSH
ssh_setup(){
  local stack="${1:-}"

  case "$stack" in
    vpm)
      SSH_HOST='rhea.ghn.me'
      SSH_USER='ubuntu'
      ;;
    monitor)
      SSH_HOST='prometheus.ghn.me'
      SSH_USER='ubuntu'
      ;;
  esac

  e_info 'Set-up SSH key'
  echo "$DEPLOY_RSA" | base64 --decode --ignore-garbage > "$SSH_KEY"
  chmod 600 "$SSH_KEY"

  e_info 'Update known hosts'
  ssh-keyscan -H "$SSH_HOST" >> ~/.ssh/known_hosts

  SSH_CMD="ssh -i ${SSH_KEY} ${SSH_USER}@${SSH_HOST}"
}

# Upload project files
upload_project(){
  ssh_setup

  e_info 'Create project folder'
  eval "$SSH_CMD" "sudo mkdir -p ${project_folder}"

  e_info 'Upload project files'
  rsync -avz -e "ssh -i ${SSH_KEY}" \
    --rsync-path 'sudo rsync' \
    --prune-empty-dirs --delete --delete-excluded --recursive \
    --include '*/' \
    --include '/docker-compose.yml' \
    --exclude "*" \
    . "${SSH_USER}@${SSH_HOST}:${project_folder}"
}

# Deploy RHEA (rsync docker-compose project files)
deploy_rhea_compose_rsync(){
  docker_project='vpm'
  project_folder="/var/local/${docker_project}"
  compose_file="${project_folder}/docker-compose.yml"

  upload_project

  e_info 'Update docker-compose'
  eval "$SSH_CMD" "docker-compose --project-name ${docker_project} --file ${compose_file} pull --parallel"
  eval "$SSH_CMD" "docker-compose --project-name ${docker_project} --file ${compose_file} up -d --build --remove-orphans"
}

# Deploy RHEA (docker-compose mode)
deploy_rhea_compose(){
  docker_project='vpm'

  ssh_setup

  e_info 'Update docker-compose'
  ( eval "$SSH_CMD" "docker-compose --project-name ${docker_project} --file /dev/stdin pull" ) < docker-compose.yml
  ( eval "$SSH_CMD" "docker-compose --project-name ${docker_project} --file /dev/stdin up -d --build --remove-orphans" ) < docker-compose.yml
}

# Deploy Swarm
deploy_swarm(){
  local stack="${1:-}"

  if [[ "$ENVTYPE" == 'production' ]] && [[ "${TRAVIS_PULL_REQUEST:-false}" == 'false' ]]; then
    load_env
    ssh_setup "$stack"
    e_info 'Deploy stack'
    ( eval "$SSH_CMD" "docker stack deploy --compose-file /dev/stdin ${stack}" ) < "${APPDIR}/swarm/${stack}.yml"
  else
    e_warn 'Deployment is only allowed in production!'
  fi
}

# Install git hooks
install_git_hooks(){
  (
  # Set working directory
  cd "$APPDIR" || exit

  for file in ${APPDIR}/hooks/*-git-hook; do
    echo "Installing ${file}"
    ln -sfn "$file" "${APPDIR}/.git/hooks/$(basename "${file%-git-hook}")"
  done
  )
}

# Clean-up
clean_up() {
  if [[ "${CI:-false}" == 'true' ]]; then
    if [[ -s "${APPDIR}/.env" ]]; then
      e_info 'Removing .env'
      rm -rf "${APPDIR:?}/.env"
    fi

    if [[ -s "$SSH_KEY" ]]; then
      if [[ "$SSH_KEY" =~ tmp. ]]; then
        e_info 'Removing temporary ssh key'
        rm -rf "${SSH_KEY:?}"
      else
        e_warn 'Could not remove temporary ssh key'
      fi
    fi
  fi
}

# Trap exit
bye(){
  clean_up; exit "${1:-0}"
}
