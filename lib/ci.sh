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

  if [[ "${TRAVIS_PULL_REQUEST:-false}" == 'true' ]]; then
    e_warn 'CloudFormation templates are not validated in Pull Requests!' # Because it needs AWS Credentials
  else
    e_info 'Validate CloudFormation templates'
    find ./cfn \( -name '*.yaml' -o -name '*.json' \) -exec sh -c \
      'echo "Checking ${1}" && aws cloudformation validate-template --template-body "file://${1}" --output table' \
      -- {} \;
  fi

  e_info 'Validate AMIs'
  eval "${APPDIR}/bin/ami" validate
}

# CI Deploy
ci_deploy(){
  e_info 'Nothing yet'
}
