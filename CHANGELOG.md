## Version 0.0.10 / 2016-05-31
  * Fix repo path ([Vlad - f47deab](https://github.com/vghn/puppet_stk/commit/f47deab514b979992cd84e65923eeb17cac1db67))
  * Fix fstab mount point ([Vlad - f801f18](https://github.com/vghn/puppet_stk/commit/f801f18292233b9dc00d4215677493ddaea1675f))

## Version 0.0.9 / 2016-05-30
  * Sign releases ([Vlad - c3a5cf3](https://github.com/vghn/puppet_stk/commit/c3a5cf37ad1631971c5ad3c3f859bd96fadcb5db))
  * Clean-up environment ([Vlad - 2515270](https://github.com/vghn/puppet_stk/commit/25152703ba66549ce5696d3b00840fe06fe8215d))
  * Clean-up cloudformation and ami user data ([Vlad - b4a03cf](https://github.com/vghn/puppet_stk/commit/b4a03cf57fe5b0bcd15e6fbd810c2fac324c3e11))
  * Update defaults ([Vlad - bc5d145](https://github.com/vghn/puppet_stk/commit/bc5d1455b3c7a9140c8a15d4cc2991a2594f2846))

## Version 0.0.8 / 2016-05-24
  * Clean-up scripts ([Vlad - 13c674e](https://github.com/vghn/puppet_stk/commit/13c674eb6bfd471133dc1ce34e68a0a35f7d35f0))
  * Add a project tag to the CloudFormation stack ([Vlad - 3f6f0f4](https://github.com/vghn/puppet_stk/commit/3f6f0f4ce85a6ed9b8f0bda92b76c03e610423d5))
  * Manage swap in Puppet ([Vlad - 48477de](https://github.com/vghn/puppet_stk/commit/48477de83324519494087d01ea3fd2d952ec8fdf))

## Version 0.0.7 / 2016-05-22
  * Clean-up CloudFormation outputs ([Vlad - 6790a02](https://github.com/vghn/puppet_stk/commit/6790a02418da8bc81f91c36f4ac575d3ed1968e5))
  * Fix the desired count queries ([Vlad - ea0ff65](https://github.com/vghn/puppet_stk/commit/ea0ff6533bfccf4b13f9110517ab259ed0523937))
  * Do not fail if bootstrap errors out ([Vlad - ebef2f8](https://github.com/vghn/puppet_stk/commit/ebef2f8c18ef3961361e4b9ba7ffa13dd75ba456))

## Version 0.0.6 / 2016-05-22
  * Open RDS Security Group ([Vlad - 014d409](https://github.com/vghn/puppet_stk/commit/014d409af036fcba7eacbdfb43deb12cd9383e44))

## Version 0.0.5 / 2016-05-21
  * Fix IAM roles ([Vlad - b1a5c0a](https://github.com/vghn/puppet_stk/commit/b1a5c0a045dc88280ac3f461d6f455a6fcdb9280))

## Version 0.0.4 / 2016-05-21
  * Mount assets bucket during instance start-up ([Vlad - 332da0d](https://github.com/vghn/puppet_stk/commit/332da0dd4a57506e59cab2c3b433e996511ba8b5))

## Version 0.0.3 / 2016-05-21
  * Run the ECS Agent during instance start-up ([Vlad - bc4c458](https://github.com/vghn/puppet_stk/commit/bc4c4587e74592f29529aa863e802a84d4d34ad8))
  * Add swap space on image, and fix python https ([Vlad - ea65d0c](https://github.com/vghn/puppet_stk/commit/ea65d0c016c0592a5a37854e7f0a4614c79dd1c6))
  * Increase memory allocation for Puppet Server ([Vlad - 836ff3c](https://github.com/vghn/puppet_stk/commit/836ff3cdae1e214616d356084b8e3d9434d0861c))
  * Add libffi to fix python https ([Vlad - 0089820](https://github.com/vghn/puppet_stk/commit/0089820899525ae0944744019d37e0fd56f784ab))
  * Add libssl to fix python https ([Vlad - d2590a3](https://github.com/vghn/puppet_stk/commit/d2590a368209eff01303e331c81cc2c7ec2e8b2b))
  * Terminate instance even if image is not available ([Vlad - e26a8aa](https://github.com/vghn/puppet_stk/commit/e26a8aae5551d3e280453dbc591de9cedd6baeb9))

## Version 0.0.2 / 2016-05-20
  * Travis should not build release branches ([Vlad - 5d3b87a](https://github.com/vghn/puppet_stk/commit/5d3b87a1f750bb7d74d3827189139bb10a58c791))
  * Mount the new path for hiera.yaml config ([Vlad - 05ec471](https://github.com/vghn/puppet_stk/commit/05ec471aa9cd12be589a14bdf72ae299eace85b8))

## Version 0.0.1 / 2016-05-20
  * Initial commit ([Vlad - caa59d3](https://github.com/vghn/puppet_stk/commit/caa59d332b3c87287f43c8ee9c9c10c600d9566a))
  * Initial import ([Vlad - bf27724](https://github.com/vghn/puppet_stk/commit/bf277243c7844342794eab3857bd9279310c3785))
  * Update pre-commit hook info ([Vlad - 0165322](https://github.com/vghn/puppet_stk/commit/0165322db74cc63bef363ed18b165c458824418a))
  * Install awscli and .env during envrc loading ([Vlad - d2dc4dd](https://github.com/vghn/puppet_stk/commit/d2dc4dd1d1c3042015582a05f752f8916064b378))
  * Fix ci install step ([Vlad - 96a61d4](https://github.com/vghn/puppet_stk/commit/96a61d4a4aa46a3c09a23b3fa216612068f25c61))
  * Fix ci install step ([Vlad - 09ca462](https://github.com/vghn/puppet_stk/commit/09ca4625313e574d40382cec6da436ae3eac7af0))
  * Fix CloudFormation scripts ([Vlad - c039cd6](https://github.com/vghn/puppet_stk/commit/c039cd6a0cb0c5725f4107fff055d4370cfea7e9))
  * Add cloudformation templates to app archive ([Vlad - 9aaff92](https://github.com/vghn/puppet_stk/commit/9aaff92648c5855bde23749b3e974740b37c40f5))
  * Use defaut travis vm ([Vlad - 72fa1e7](https://github.com/vghn/puppet_stk/commit/72fa1e742b3151af42988bece3bf77f849abf801))
  * Fix CloudFormation scripts ([Vlad - 32906e8](https://github.com/vghn/puppet_stk/commit/32906e847d95ecf9694f24b4ee9be9622fff76fa))
  * Fix CloudFormation user-data ([Vlad - 922ecd7](https://github.com/vghn/puppet_stk/commit/922ecd721019f2ee251a129393fb24fd9d15bcc2))
  * Fix CloudFormation user-data ([Vlad - 79ade0a](https://github.com/vghn/puppet_stk/commit/79ade0aa6f597799437b4cf957c49b43ee9e608d))
  * Wait before image power off ([Vlad - 9a24954](https://github.com/vghn/puppet_stk/commit/9a249548feef2116d1f2e4e7fec074aedfc68cf4))
  * Always have one instance in service ([Vlad - 11e8134](https://github.com/vghn/puppet_stk/commit/11e81340351fa656be7daa03cc9979601432b8a3))
  * Fix AutoScaling group ([Vlad - ca67f1c](https://github.com/vghn/puppet_stk/commit/ca67f1cd25bfb7e36446343a56df16552046a1a9))
  * Improve installation of the VGS library ([Vlad - e0954ca](https://github.com/vghn/puppet_stk/commit/e0954ca738d81e4d8c96dd62af84b6759366a2e2))
  * Clean-up code ([Vlad - becbfe4](https://github.com/vghn/puppet_stk/commit/becbfe40f12fa1b88c9994ab4f881502687ecbe1))
  * Use a build directory during ami bootstrap ([Vlad - 61b06d9](https://github.com/vghn/puppet_stk/commit/61b06d96e8f3b5ae3153a0c16b12884a502b5b65))
  * Install Git during image bootstrap ([Vlad - 0283deb](https://github.com/vghn/puppet_stk/commit/0283debb366812d5ac5dfb61f4af5c504fd21c2c))
  * Increase Puppet Server container memory allocation ([Vlad - c125365](https://github.com/vghn/puppet_stk/commit/c125365a3a96669c68519362d726f3448f62d9c8))
  * Reconfigure hiera when instance starts ([Vlad - 59f5851](https://github.com/vghn/puppet_stk/commit/59f58512cef60d6b05f06db08a81007c6da6c032))
  * Replace the sync agent container with a s3fs mount ([Vlad - 5cfff80](https://github.com/vghn/puppet_stk/commit/5cfff8069274eed470206c379b36796b263f901f))
  * Decalre containers in Puppet ([Vlad - c85ac09](https://github.com/vghn/puppet_stk/commit/c85ac092f4e274027c7e2283b562a9e8275c4943))
  * ELB should check if Puppet Master is up ([Vlad - d36f1a5](https://github.com/vghn/puppet_stk/commit/d36f1a5c577c104eab23c186dffd2a8243600da0))
  * Tweak Puppet Master memory ([Vlad - 1f82da9](https://github.com/vghn/puppet_stk/commit/1f82da9782a92f1067fa16cd3f084d86352e656f))
  * Move hiera config to confdir ([Vlad - d8c4b6c](https://github.com/vghn/puppet_stk/commit/d8c4b6cf591b9d537bdeba3254bd61e399bf4c34))
  * Clean-up CloudFormation parameters ([Vlad - f80f7f5](https://github.com/vghn/puppet_stk/commit/f80f7f5c5b185d9d01598cd65a55917b85b7974f))
  * Use the upstream bootstrap script in user data ([Vlad - 281b6e0](https://github.com/vghn/puppet_stk/commit/281b6e0d5efa13b1c2ba62a9eedfedfec19448db))
  * Version should default to 0.0.0 if missing ([Vlad - 316bfbe](https://github.com/vghn/puppet_stk/commit/316bfbe7cb5f389f533b3aab0342a133cdc254ab))
