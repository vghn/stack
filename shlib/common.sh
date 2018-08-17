#!/usr/bin/env bash
# Common functions

# Output
e_ok()    { printf "  ✔  %s\\n" "$@" ;}
e_info()  { printf "  ➜  %s\\n" "$@" ;}
e_error() { printf "  ✖  %s\\n" "$@" ;}
e_warn()  { printf "    %s\\n" "$@" ;}
e_abort() { e_error "$1"; return "${2:-1}" ;}

# Get Terraform output
tf_output(){
  (
    cd "${APPDIR}/terraform" || return
    terraform output "${1:-}"
  )
}

# Set-up SSH
ssh_setup(){
  e_info 'Set-up SSH key'

  SSH_USER="${SSH_USER:-ubuntu}"
  SSH_KEY=$(mktemp 2>/dev/null || mktemp -t 'tmp')

  echo "${DEPLOY_RSA:-}" | base64 --decode --ignore-garbage > "$SSH_KEY"
  chmod 600 "$SSH_KEY"

  SSH_CMD="ssh -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -i ${SSH_KEY} ${SSH_USER}@${SSH_HOST}"
}

# Deploy Swarm
deploy_swarm(){
  local stack="${1:-}"

  if [[ -z "$stack" ]]; then
    e_warn 'Stack name is required'
  fi

  if [[ "$ENVTYPE" == 'production' ]] && [[ "${TRAVIS_PULL_REQUEST:-false}" == 'false' ]]; then
    e_info 'Deploy stack'
    ssh_setup
    ( eval "$SSH_CMD" "docker stack deploy --compose-file /dev/stdin ${stack}" ) < "${APPDIR}/swarm/${stack}.yml"
  else
    e_warn 'Deployment is only allowed in production!'
  fi
}

# Clean-up
clean_up() {
  if [[ "${CI:-false}" == 'true' ]]; then
    if [[ -s "${APPDIR}/.env" ]]; then
      e_info 'Removing .env'
      rm -rf "${APPDIR:?}/.env"
    fi

    if [[ -s "$SSH_KEY:-" ]]; then
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
