#!/usr/bin/env bash
# Miscellaneous tasks

# Load VGS Library (install if needed)
ensure_vgs(){
  if ! command -v curl >/dev/null 2>&1; then
    echo 'Installing curl'
    apt-get -qy install curl < /dev/null
  fi

  echo 'Install/Update VGS Library'
  local installdir
  if [[ $EUID == 0 ]]; then installdir=/opt/vgs; else installdir=~/vgs; fi

  echo '- Remove any existing installations'
  if [[ -d "$installdir" ]]; then rm -fr "$installdir"; fi
  mkdir -p "$installdir"

  echo '- Downloading VGS library'
  curl -sSL https://s3.amazonaws.com/vghn/vgs.tgz | tar xz -C "$installdir"

  echo '- Load VGS Library'
  # shellcheck disable=1090
  . "${installdir}/load"
}

# Ensure AWSCLI
ensure_awscli(){
  echo 'Ensure latest Python PIP and AWS-CLI'
  pip install --user --upgrade pip awscli
}

# Get dotenv
get_dotenv(){
  e_info 'Get .env'
  aws s3 cp "$DOTENV_S3" "$DOTENV" || true
}

# Get dotenv
upload_dotenv(){
  e_info 'Upload .env'
  aws s3 cp "$DOTENV" "$DOTENV_S3" || true
}
