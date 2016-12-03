#!/usr/bin/env bash
# Continuous Integration / Continuous Deployment tasks

# CI Install
ci_install(){
  echo 'Install VGS library'
  git clone https://github.com/vghn/vgs.git ~/vgs

  # Load VGS library (https://github.com/vghn/vgs)
  echo 'Reload VGS library'
  # shellcheck disable=1090
  . ~/vgs/load 2>/dev/null || true

  echo 'Install AWS-CLI'
  pip install --user --upgrade awscli

  echo 'Install HashiCorp Packer'
  curl -L -o packer.zip https://releases.hashicorp.com/packer/0.12.0/packer_0.12.0_linux_amd64.zip
  unzip -d ~/bin packer.zip
}

# CI Test
ci_test(){
  e_info 'Validate BASH scripts'
  find ./{bin,hooks,lib} -type f -exec shellcheck {} +

  if [[ "${TRAVIS_PULL_REQUEST:-false}" == 'false' ]]; then
    e_info 'Validate CloudFormation templates'
    find ./cfn \( -name '*.yaml' -o -name '*.json' \) -exec sh -c \
      'echo "Checking ${1}" && aws cloudformation validate-template --template-body "file://${1}" --output table' \
      -- {} \;
  else
    e_warn 'CloudFormation templates are not validated in Pull Requests!' # Because it needs AWS Credentials
  fi

  e_info 'Validate AMIs'
  eval "${APPDIR}/bin/ami" validate
}

# CI Deploy
ci_deploy(){
  if [[ "${TRAVIS_PULL_REQUEST:-false}" == 'false' ]]; then
    # Set-up SSH connection
    echo "$DEPLOY_RSA" | base64 --decode --ignore-garbage > ~/.ssh/deploy_rsa
    chmod 600 ~/.ssh/deploy_rsa
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/deploy_rsa
    ssh-keyscan -H puppet.ghn.me >> ~/.ssh/known_hosts

    # Update docker-compose
    ( ssh ubuntu@puppet.ghn.me 'docker-compose --project-name vpm --file - pull' ) < docker-compose.yml
    ( ssh ubuntu@puppet.ghn.me 'docker-compose --project-name vpm --file - up -d' ) < docker-compose.yml
  else
    e_warn 'SSH deployment skipped for Pull Requests!'
  fi
}
