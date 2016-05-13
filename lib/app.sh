#!/usr/bin/env bash
# Application tasks

# Archive app files
app_package_files(){
  app_archive_path="${TMPDIR}/${APP_ARCHIVE}"

  # Only pack essential files
  e_info "Creating application archive (${app_archive_path})"
  if ! tar cvzf "$app_archive_path" \
    bin/ cfn/ lib/ .env envrc \
    CHANGELOG.md LICENSE README.md VERSION;
  then
    e_abort "Could not create ${app_archive_path}"
  fi
}

# Upload archive to S3
app_upload_archive(){
  e_info "Uploading app archive to S3 (${APP_ARCHIVE_S3})"
  if ! aws s3 cp "$app_archive_path" "$APP_ARCHIVE_S3"; then
    e_abort "Could not upload ${app_archive_path} to ${APP_ARCHIVE_S3}"
  fi

  e_info "Creating latest app archive (${APP_ARCHIVE_S3_LATEST})"
  if ! aws s3 cp "$APP_ARCHIVE_S3" "$APP_ARCHIVE_S3_LATEST"; then
    e_abort "Could not create latest app archive (${APP_ARCHIVE_S3_LATEST})"
  fi
}

# Clean-up
app_clean(){
  e_info "Cleaning-up ${app_archive_path}"
  rm "$app_archive_path" || true
}

# Upload app
app_upload(){
  e_info "Upload application"
  app_package_files && app_upload_archive && app_clean
}
