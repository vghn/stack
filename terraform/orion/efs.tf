resource "aws_efs_file_system" "prometheus" {
  tags = "${merge(
    var.common_tags,
    map(
      "Name", "Prometheus"
    )
  )}"
}

resource "aws_efs_mount_target" "prometheus1" {
  file_system_id  = "${aws_efs_file_system.prometheus.id}"
  subnet_id       = "${element(module.vpc.public_subnets, 0)}"
  security_groups = ["${module.prometheus_efs_sg.this_security_group_id}"]
}

resource "aws_efs_mount_target" "prometheus2" {
  file_system_id  = "${aws_efs_file_system.prometheus.id}"
  subnet_id       = "${element(module.vpc.public_subnets, 1)}"
  security_groups = ["${module.prometheus_efs_sg.this_security_group_id}"]
}

resource "aws_efs_mount_target" "prometheus3" {
  file_system_id  = "${aws_efs_file_system.prometheus.id}"
  subnet_id       = "${element(module.vpc.public_subnets, 2)}"
  security_groups = ["${module.prometheus_efs_sg.this_security_group_id}"]
}

resource "aws_efs_mount_target" "prometheus4" {
  file_system_id  = "${aws_efs_file_system.prometheus.id}"
  subnet_id       = "${element(module.vpc.public_subnets, 3)}"
  security_groups = ["${module.prometheus_efs_sg.this_security_group_id}"]
}

module "prometheus_efs_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "2.1.0"

  name        = "Prometheus EFS"
  description = "Security group for the Prometheus EFS"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_with_source_security_group_id = [{
    rule                     = "all-all"
    source_security_group_id = "${module.prometheus_sg.this_security_group_id}"
  }]

  ingress_with_self = [{
    rule = "all-all"
  }]

  egress_rules = ["all-all"]

  tags = "${var.common_tags}"
}
