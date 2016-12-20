#!/usr/bin/env bash
# Common tasks

upload_env(){
  e_info 'Upload .env'
  if ! aws s3 cp "${APPDIR}/.env" "${AWS_ENV_S3PATH}" --quiet; then
    e_abort "Could not upload ${APPDIR}/.env to ${AWS_ENV_S3PATH}"
  fi
}

download_env(){
  e_info 'Download .env'
  if ! aws s3 cp "${AWS_ENV_S3PATH}" "${APPDIR}/.env" --quiet; then
    e_abort "Could not download ${AWS_ENV_S3PATH} to ${APPDIR}/.env"
  fi
}
