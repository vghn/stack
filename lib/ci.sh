#!/usr/bin/env bash
# Continuous Integration / Continuous Deployment tasks

# CI Install
ci_install(){
  echo 'Install VGS library'
  git clone https://github.com/vghn/vgs.git ~/vgs

  echo 'Install AWS-CLI'
  pip install --user --upgrade awscli

  echo 'Download .env'
  download_env
}

# CI Test
ci_test(){
  e_info 'Nothing yet'
}

# CI Deploy
ci_deploy(){
  e_info 'Nothing yet'
}
