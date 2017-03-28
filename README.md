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

### .env
Contains secret environment variables.
**DO NOT COMMIT THIS FILE**

### envrc
Contains global variables.
**All variables declared here are public**

### ami-packer.json
Contains the AWS AMI configurations.

### docker-compose.yml
Contains the Docker Compose stack.

## Contribute
Bug reports and pull requests are welcome. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
1. Open an issue to discuss proposed changes
2. Fork the repository
3. Create your feature branch: `git checkout -b my-new-feature`
4. Commit your changes: `git commit -am 'Add some feature'`
5. Push to the branch: `git push origin my-new-feature`
6. Submit a pull request :D

## License
Licensed under the Apache License, Version 2.0.
