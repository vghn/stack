# Assets S3 Bucket
resource "aws_s3_bucket" "prometheus" {
  bucket = "prometheus-vghn"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = "${var.common_tags}"
}

# Prometheus Security Group
module "prometheus_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "2.1.0"

  name        = "Prometheus"
  description = "Security group for the Prometheus"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = [
    "ssh-tcp",
    "https-443-tcp",
    "http-80-tcp",
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 8
      to_port     = 0
      protocol    = "icmp"
      description = "Ping"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 10514
      to_port     = 10514
      protocol    = "tcp"
      description = "Log server ports"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  ingress_with_self = [{
    rule = "all-all"
  }]

  egress_rules = ["all-all"]

  tags = "${var.common_tags}"
}

resource "aws_iam_instance_profile" "prometheus" {
  name = "prometheus"
  role = "${aws_iam_role.prometheus.name}"
}

data "aws_ami" "prometheus" {
  most_recent = true
  owners      = ["self"]
  name_regex  = "^Prometheus_.*"

  filter {
    name   = "tag:Group"
    values = ["vgh"]
  }

  filter {
    name   = "tag:Project"
    values = ["vgh"]
  }
}

resource "aws_eip" "prometheus" {
  vpc        = true
  instance   = "${aws_instance.prometheus.id}"
  depends_on = ["module.vpc"]

  tags = "${merge(
    var.common_tags,
    map(
      "Name", "Prometheus"
    )
  )}"
}

resource "aws_instance" "prometheus" {
  instance_type               = "t3.micro"
  ami                         = "${data.aws_ami.prometheus.id}"
  subnet_id                   = "${element(module.vpc.public_subnets, 0)}"
  vpc_security_group_ids      = ["${module.prometheus_sg.this_security_group_id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.prometheus.name}"
  key_name                    = "vgh"
  associate_public_ip_address = true

  user_data = <<DATA
#!/usr/bin/env bash
set -euo pipefail
IFS=$$'\n\t'

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo 'Update APT'
while ! apt-get -y update; do sleep 1; done
apt-get -qy upgrade

echo 'Configure AWS Credentials'
aws configure --profile ursa set region us-east-1
aws configure --profile ursa set role_arn ${var.ursa_prometheus_role}
aws configure --profile ursa set credential_source Ec2InstanceMetadata

echo 'Set environment'
export PP_SERVER='puppet.ghn.me'
export PP_ROLE='prometheus'
export PP_PROJECT='vgh'
export PP_APPLICATION='monitoring'
export PP_AGENT_CERT_REGEN=true
export PP_SECRET='${var.puppet_secret}'
export PP_CERTNAME="$$(curl --max-time 2 -s http://169.254.169.254/latest/meta-data/instance-id || hostname)"

echo 'Run Puppet'
wget -qO- 'https://raw.githubusercontent.com/vghn/puppet/production/bin/bootstrap' | sudo -E bash

echo 'Mount EBS & EFS'
sudo mkdir -p /mnt/data && sudo mount /dev/xvdg /mnt/data
sudo mkdir -p /mnt/efs && sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.prometheus.dns_name}:/ /mnt/efs

echo 'Restore Docker Swarm state'
sudo service docker stop
sudo rm -rf /var/lib/docker/swarm && sudo mkdir -p /var/lib/docker/swarm
aws s3 cp --no-progress s3://${aws_s3_bucket.prometheus.id}/swarm.tar.xz.gpg - | gpg --batch --yes --pinentry-mode loopback --passphrase "$$(aws --region us-east-1 ssm get-parameter --with-decryption --name /prometheus/encryption_key  --query Parameter.Value --output text --profile ursa)" --decrypt | sudo tar xJ -C /var/lib/docker/swarm
sudo service docker start

echo 'Reinitialize cluster'
sudo docker swarm init --force-new-cluster
sudo service docker restart # It needs to be restarted for the advertised address to change because the ip probably changed

echo 'Set-up cronjob to save Docker Swarm state'
echo "sudo /bin/tar cJ -C /var/lib/docker/swarm . | /usr/bin/gpg --batch --yes --pinentry-mode loopback --passphrase '$$(aws --region us-east-1 ssm get-parameter --with-decryption --name /prometheus/encryption_key  --query Parameter.Value --output text --profile ursa)' --cipher-algo AES256 --s2k-digest-algo SHA512 --symmetric  | /usr/local/bin/aws s3 cp --sse AES256 - s3://${aws_s3_bucket.prometheus.id}/swarm.tar.xz.gpg" | sudo tee /usr/local/sbin/docker_swarm_state >/dev/null
chmod 500 /usr/local/sbin/docker_swarm_state
echo '3 * * * * root bash /usr/local/sbin/docker_swarm_state' | sudo tee /etc/cron.d/docker_swarm_state

echo "FINISHED @ $(date "+%m-%d-%Y %T")" | sudo tee /var/lib/cloud/instance/deployed
DATA

  tags = "${merge(
    var.common_tags,
    map(
      "Name", "Prometheus"
    )
  )}"
}

resource "aws_ebs_volume" "prometheus_data" {
  availability_zone = "us-east-1a"
  type              = "gp2"
  size              = 10

  snapshot_id = "snap-0d96a2beb91b7b82d"

  tags = "${merge(
    var.common_tags,
    map(
      "Name", "Prometheus"
    )
  )}"
}

resource "aws_volume_attachment" "prometheus_data_attachment" {
  device_name  = "/dev/sdg"
  instance_id  = "${aws_instance.prometheus.id}"
  volume_id    = "${aws_ebs_volume.prometheus_data.id}"
  skip_destroy = true
}
