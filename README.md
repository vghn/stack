# VGH Stack
  [![Build Status](https://travis-ci.org/vghn/stack.svg?branch=master)](https://travis-ci.org/vghn/stack)

## Development status ##
This project is still in a prototype development stage.

## Overview
Vlad's Stack.

## Description
### bin/
Contains various executable scripts.

### cfn/
Contains AWS CloudFormation templates.

### hooks/
Contains GIT repository hooks.

### lib/
Contains various functions that can be sourced in other scripts.

### envrc
This file contains global variables.
**All variables declared here are public**

### ami-packer.json
This file contains the AWS AMI configurations.

## Development

- Upload deployment ssh key

  ```SH
  # Prepare
  gem install travis
  travis login
  # Create key
  ssh-keygen -t rsa -b 4096 -C 'travis' -f ~/.ssh/deploy_rsa
  # Set a secret environment variable in TravisCI
  travis env set DEPLOY_RSA $(base64 --wrap=0 ~/.ssh/deploy_rsa)
  # Add to server's known keys
  cat ~/.ssh/deploy_rsa | ssh -i user@ssh.example.com 'cat >> .ssh/authorized_keys && echo "Key copied"'
  ```

  ```YAML
  # .travis.yml
  before_deploy:
    echo "$DEPLOY_RSA" | base64 --decode --ignore-garbage > ~/.ssh/deploy_rsa;
    chmod 600 ~/.ssh/deploy_rsa;
    eval "$(ssh-agent -s)";
    ssh-add ~/.ssh/deploy_rsa;
    ssh-keyscan -H ssh.example.com >> ~/.ssh/known_hosts;
  ```

## Contribute
1. Open an issue to discuss proposed changes
2. Fork the repository
3. Create your feature branch: `git checkout -b my-new-feature`
4. Commit your changes: `git commit -am 'Add some feature'`
5. Push to the branch: `git push origin my-new-feature`
6. Submit a pull request :D

## License
Licensed under the Apache License, Version 2.0.
