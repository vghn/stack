# Change Log

## [v0.2.2](https://github.com/vghn/stack/tree/v0.2.2) (2017-08-12)
[Full Changelog](https://github.com/vghn/stack/compare/v0.2.1...v0.2.2)

**Implemented enhancements:**

- Webhook should redirect to https [\#97](https://github.com/vghn/stack/issues/97)
- Clean-up networks [\#96](https://github.com/vghn/stack/issues/96)
- Separate the webhook app from other traffic through the load balancer [\#95](https://github.com/vghn/stack/issues/95)
- Separate Puppet Server from HAProxy [\#94](https://github.com/vghn/stack/issues/94)
- Tune Puppet Server and DB memory [\#92](https://github.com/vghn/stack/issues/92)
- Revert to Papertrail for logs [\#91](https://github.com/vghn/stack/issues/91)
- Use better algorithms for .env encryption [\#89](https://github.com/vghn/stack/issues/89)
- Upgrade Packer [\#86](https://github.com/vghn/stack/issues/86)
- Switch to Traefik [\#98](https://github.com/vghn/stack/pull/98) ([vladgh](https://github.com/vladgh))
- Reorganize BASH functions and CLI [\#90](https://github.com/vghn/stack/pull/90) ([vladgh](https://github.com/vladgh))
- Use a GPG encrypted .env [\#87](https://github.com/vghn/stack/pull/87) ([vladgh](https://github.com/vladgh))

**Fixed bugs:**

- Wait for Puppet SSL certificates to be downloaded [\#93](https://github.com/vghn/stack/issues/93)
- Reload environment after decrypting .env [\#88](https://github.com/vghn/stack/issues/88)

## [v0.2.1](https://github.com/vghn/stack/tree/v0.2.1) (2017-07-11)
[Full Changelog](https://github.com/vghn/stack/compare/v0.2.0...v0.2.1)

**Implemented enhancements:**

- Adhere to recommended community standards [\#85](https://github.com/vghn/stack/issues/85)
- Upgrade Packer version [\#84](https://github.com/vghn/stack/issues/84)
- Improve swarm secrets [\#83](https://github.com/vghn/stack/issues/83)
- Remove hardcoded AWS credentials location [\#82](https://github.com/vghn/stack/issues/82)
- Use global mode for services that require it [\#81](https://github.com/vghn/stack/issues/81)
- Use node labels instead of engine ones [\#80](https://github.com/vghn/stack/issues/80)
- Upgrade docker-compose file version [\#79](https://github.com/vghn/stack/issues/79)
- Constrain Puppet related services to the Rhea role [\#78](https://github.com/vghn/stack/issues/78)
- Add Logz.io to the stack [\#77](https://github.com/vghn/stack/pull/77) ([vladgh](https://github.com/vladgh))
- Remove the log agent for now [\#76](https://github.com/vghn/stack/pull/76) ([vladgh](https://github.com/vladgh))
- Improve AWS credentials for Puppet [\#75](https://github.com/vghn/stack/pull/75) ([vladgh](https://github.com/vladgh))
- Finish transition to Docker Swarm secrets [\#74](https://github.com/vghn/stack/pull/74) ([vladgh](https://github.com/vladgh))
- Refactor Puppet to use Docker secrets [\#73](https://github.com/vghn/stack/pull/73) ([vladgh](https://github.com/vladgh))
- Add secrets to Webhook and update CI docs [\#72](https://github.com/vghn/stack/pull/72) ([vladgh](https://github.com/vladgh))
- Use Docker Secrets in PuppetDB [\#70](https://github.com/vghn/stack/pull/70) ([vladgh](https://github.com/vladgh))
- Update CI script to add docker secrets [\#69](https://github.com/vghn/stack/pull/69) ([vladgh](https://github.com/vladgh))
- Convert the stack to Docker Swarm [\#68](https://github.com/vghn/stack/pull/68) ([vladgh](https://github.com/vladgh))
- Minor changes [\#67](https://github.com/vghn/stack/pull/67) ([vladgh](https://github.com/vladgh))
- Improve secrets [\#65](https://github.com/vghn/stack/pull/65) ([vladgh](https://github.com/vladgh))
- Add haproxy stats [\#64](https://github.com/vghn/stack/pull/64) ([vladgh](https://github.com/vladgh))
- Tweak memory requirements [\#62](https://github.com/vghn/stack/pull/62) ([vladgh](https://github.com/vladgh))
- Add Puppet Board [\#61](https://github.com/vghn/stack/pull/61) ([vladgh](https://github.com/vladgh))
- Improve docker-compose namespace and deployment [\#60](https://github.com/vghn/stack/pull/60) ([vladgh](https://github.com/vladgh))
- Add notifications CloudFormation template [\#58](https://github.com/vghn/stack/pull/58) ([vladgh](https://github.com/vladgh))
- Lower RAM requirements for Puppet Server [\#57](https://github.com/vghn/stack/pull/57) ([vladgh](https://github.com/vladgh))

**Fixed bugs:**

- Fix PuppetDB secrets [\#71](https://github.com/vghn/stack/pull/71) ([vladgh](https://github.com/vladgh))
- Fix haproxy hostname [\#63](https://github.com/vghn/stack/pull/63) ([vladgh](https://github.com/vladgh))
- Make sure all services get restarted [\#59](https://github.com/vghn/stack/pull/59) ([vladgh](https://github.com/vladgh))

## [v0.2.0](https://github.com/vghn/stack/tree/v0.2.0) (2017-04-17)
[Full Changelog](https://github.com/vghn/stack/compare/v0.1.1...v0.2.0)

**Implemented enhancements:**

- Add a Docker Cloud Swarm Role CloudFormation template [\#55](https://github.com/vghn/stack/pull/55) ([vladgh](https://github.com/vladgh))
- Add PuppetDB [\#53](https://github.com/vghn/stack/pull/53) ([vladgh](https://github.com/vladgh))
- Improve CloudFormation templates [\#52](https://github.com/vghn/stack/pull/52) ([vladgh](https://github.com/vladgh))
- Store secrets in volatile memory [\#50](https://github.com/vghn/stack/pull/50) ([vladgh](https://github.com/vladgh))
- Upgrade Packer [\#49](https://github.com/vghn/stack/pull/49) ([vladgh](https://github.com/vladgh))
- Add DEBUG global variable [\#48](https://github.com/vghn/stack/pull/48) ([vladgh](https://github.com/vladgh))
- Remove Faradaygem version requirement [\#47](https://github.com/vghn/stack/pull/47) ([vladgh](https://github.com/vladgh))
- Minor changes [\#46](https://github.com/vghn/stack/pull/46) ([vladgh](https://github.com/vladgh))
- Use the new release task options and a CRON\_TIME variable to stack [\#45](https://github.com/vghn/stack/pull/45) ([vladgh](https://github.com/vladgh))
- Migrate to Vtasks [\#42](https://github.com/vghn/stack/pull/42) ([vladgh](https://github.com/vladgh))
- Add Code of Conduct [\#41](https://github.com/vghn/stack/pull/41) ([vladgh](https://github.com/vladgh))
- Add LetsEncrypt [\#40](https://github.com/vghn/stack/pull/40) ([vladgh](https://github.com/vladgh))
- Improve CI scripts [\#39](https://github.com/vghn/stack/pull/39) ([vladgh](https://github.com/vladgh))
- Improve the deployment process [\#37](https://github.com/vghn/stack/pull/37) ([vladgh](https://github.com/vladgh))
- Add a CloudFormation template for the main account [\#35](https://github.com/vghn/stack/pull/35) ([vladgh](https://github.com/vladgh))
- Use the new rake tasks modules [\#34](https://github.com/vghn/stack/pull/34) ([vladgh](https://github.com/vladgh))
- Add lifecycle rules for the backup buckets [\#33](https://github.com/vghn/stack/pull/33) ([vladgh](https://github.com/vladgh))
- Add a backup container [\#32](https://github.com/vghn/stack/pull/32) ([vladgh](https://github.com/vladgh))
- Improve Puppet CSR [\#31](https://github.com/vghn/stack/pull/31) ([vladgh](https://github.com/vladgh))
- Remove the vg-secrets bucket [\#30](https://github.com/vghn/stack/pull/30) ([vladgh](https://github.com/vladgh))
- Improve hiera data and secrets [\#29](https://github.com/vghn/stack/pull/29) ([vladgh](https://github.com/vladgh))
- Use a new secrets store S3 bucket and Hiera Eyaml [\#27](https://github.com/vghn/stack/pull/27) ([vladgh](https://github.com/vladgh))
- Use the default cache dir for R10K [\#26](https://github.com/vghn/stack/pull/26) ([vladgh](https://github.com/vladgh))
- Update options for API and Server images [\#25](https://github.com/vghn/stack/pull/25) ([vladgh](https://github.com/vladgh))
- Let the CI user have administrator privileges [\#24](https://github.com/vghn/stack/pull/24) ([vladgh](https://github.com/vladgh))
- Only deploy from the master branch [\#23](https://github.com/vghn/stack/pull/23) ([vladgh](https://github.com/vladgh))
- Fix ami validate pre-commit hook and clean environment [\#22](https://github.com/vghn/stack/pull/22) ([vladgh](https://github.com/vladgh))
- Add task to update Travis environment variables from .env [\#21](https://github.com/vghn/stack/pull/21) ([vladgh](https://github.com/vladgh))
- Minor improvements [\#20](https://github.com/vghn/stack/pull/20) ([vladgh](https://github.com/vladgh))
- Use BASH language for Travis [\#19](https://github.com/vghn/stack/pull/19) ([vladgh](https://github.com/vladgh))
- Add rake task to update stack through SSH [\#18](https://github.com/vghn/stack/pull/18) ([vladgh](https://github.com/vladgh))

**Fixed bugs:**

- Fix PuppetDB hostname and JAVA\_ARGS [\#54](https://github.com/vghn/stack/pull/54) ([vladgh](https://github.com/vladgh))
- Rename docker images [\#44](https://github.com/vghn/stack/pull/44) ([vladgh](https://github.com/vladgh))
- Fix SSH deployment [\#43](https://github.com/vghn/stack/pull/43) ([vladgh](https://github.com/vladgh))
- Improve ssh key clean-up after deployment [\#38](https://github.com/vghn/stack/pull/38) ([vladgh](https://github.com/vladgh))
- Use ubuntu user for deployment [\#36](https://github.com/vghn/stack/pull/36) ([vladgh](https://github.com/vladgh))
- Fix volumes declaration [\#28](https://github.com/vghn/stack/pull/28) ([vladgh](https://github.com/vladgh))

**Merged pull requests:**

- Add a parallel option to docker-compose pull [\#56](https://github.com/vghn/stack/pull/56) ([vladgh](https://github.com/vladgh))
- Improve deployment script and PuppetServer environment variables [\#51](https://github.com/vghn/stack/pull/51) ([vladgh](https://github.com/vladgh))

## [v0.1.1](https://github.com/vghn/stack/tree/v0.1.1) (2017-01-07)
[Full Changelog](https://github.com/vghn/stack/compare/v0.1.0...v0.1.1)

**Implemented enhancements:**

- Consolidate rake tasks and bash scripts [\#16](https://github.com/vghn/stack/pull/16) ([vladgh](https://github.com/vladgh))
- Use the Ruby version that is preinstalled on Travis [\#15](https://github.com/vghn/stack/pull/15) ([vladgh](https://github.com/vladgh))
- Update LICENSE [\#14](https://github.com/vghn/stack/pull/14) ([vladgh](https://github.com/vladgh))
- Clean-up docker-compose.yml [\#13](https://github.com/vghn/stack/pull/13) ([vladgh](https://github.com/vladgh))
- Refactor [\#11](https://github.com/vghn/stack/pull/11) ([vladgh](https://github.com/vladgh))
- Rename folder for sensitive files to `./secure` [\#10](https://github.com/vghn/stack/pull/10) ([vladgh](https://github.com/vladgh))
- Separate BASH libraries from Ruby [\#9](https://github.com/vghn/stack/pull/9) ([vladgh](https://github.com/vladgh))
- Replace sync image [\#8](https://github.com/vghn/stack/pull/8) ([vladgh](https://github.com/vladgh))
- Improve Rakefile [\#6](https://github.com/vghn/stack/pull/6) ([vladgh](https://github.com/vladgh))

**Fixed bugs:**

- Bring back upload\_env function [\#17](https://github.com/vghn/stack/pull/17) ([vladgh](https://github.com/vladgh))
- Rename DATA\_CONFIG to API\_CONFIG [\#12](https://github.com/vghn/stack/pull/12) ([vladgh](https://github.com/vladgh))
- Move .env S3 path [\#7](https://github.com/vghn/stack/pull/7) ([vladgh](https://github.com/vladgh))
- Use after\_success hook for deployment [\#5](https://github.com/vghn/stack/pull/5) ([vladgh](https://github.com/vladgh))

## [v0.1.0](https://github.com/vghn/stack/tree/v0.1.0) (2016-12-03)
[Full Changelog](https://github.com/vghn/stack/compare/v0.0.14...v0.1.0)

**Implemented enhancements:**

- Add docker-compose environment and ssh deployment [\#4](https://github.com/vghn/stack/pull/4) ([vladgh](https://github.com/vladgh))
- Improvements [\#3](https://github.com/vghn/stack/pull/3) ([vladgh](https://github.com/vladgh))

**Fixed bugs:**

- Major refactor [\#2](https://github.com/vghn/stack/pull/2) ([vladgh](https://github.com/vladgh))

## [v0.0.14](https://github.com/vghn/stack/tree/v0.0.14) (2016-06-02)
[Full Changelog](https://github.com/vghn/stack/compare/v0.0.13...v0.0.14)

## [v0.0.13](https://github.com/vghn/stack/tree/v0.0.13) (2016-06-02)
[Full Changelog](https://github.com/vghn/stack/compare/v0.0.12...v0.0.13)

## [v0.0.12](https://github.com/vghn/stack/tree/v0.0.12) (2016-06-02)
[Full Changelog](https://github.com/vghn/stack/compare/v0.0.11...v0.0.12)

## [v0.0.11](https://github.com/vghn/stack/tree/v0.0.11) (2016-06-02)
[Full Changelog](https://github.com/vghn/stack/compare/v0.0.10...v0.0.11)

## [v0.0.10](https://github.com/vghn/stack/tree/v0.0.10) (2016-05-31)
[Full Changelog](https://github.com/vghn/stack/compare/v0.0.9...v0.0.10)

## [v0.0.9](https://github.com/vghn/stack/tree/v0.0.9) (2016-05-31)
[Full Changelog](https://github.com/vghn/stack/compare/v0.0.8...v0.0.9)

## [v0.0.8](https://github.com/vghn/stack/tree/v0.0.8) (2016-05-24)
[Full Changelog](https://github.com/vghn/stack/compare/v0.0.7...v0.0.8)

## [v0.0.7](https://github.com/vghn/stack/tree/v0.0.7) (2016-05-23)
[Full Changelog](https://github.com/vghn/stack/compare/v0.0.6...v0.0.7)

## [v0.0.6](https://github.com/vghn/stack/tree/v0.0.6) (2016-05-22)
[Full Changelog](https://github.com/vghn/stack/compare/v0.0.5...v0.0.6)

**Fixed bugs:**

- RDS Security Group Configuration Does Not Allow Inbound Connections [\#1](https://github.com/vghn/stack/issues/1)

## [v0.0.5](https://github.com/vghn/stack/tree/v0.0.5) (2016-05-22)
[Full Changelog](https://github.com/vghn/stack/compare/v0.0.4...v0.0.5)

## [v0.0.4](https://github.com/vghn/stack/tree/v0.0.4) (2016-05-21)
[Full Changelog](https://github.com/vghn/stack/compare/v0.0.3...v0.0.4)

## [v0.0.3](https://github.com/vghn/stack/tree/v0.0.3) (2016-05-21)
[Full Changelog](https://github.com/vghn/stack/compare/v0.0.2...v0.0.3)

## [v0.0.2](https://github.com/vghn/stack/tree/v0.0.2) (2016-05-21)
[Full Changelog](https://github.com/vghn/stack/compare/v0.0.1...v0.0.2)

## [v0.0.1](https://github.com/vghn/stack/tree/v0.0.1) (2016-05-21)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*