# PuppetDB RDS Instance
module "puppetdb" {
  source  = "terraform-aws-modules/rds/aws"
  version = "1.19.0"

  identifier = "puppetdb"

  # snapshot_identifier       = "${data.aws_db_snapshot.puppetdb_snapshot.id}"
  snapshot_identifier       = "rds:puppetdb-2018-07-28-20-06"
  final_snapshot_identifier = "puppetdb"
  skip_final_snapshot       = false
  copy_tags_to_snapshot     = true

  multi_az = false

  family = "postgres10"

  engine                      = "postgres"
  engine_version              = "10"
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false

  instance_class    = "db.t2.micro"
  allocated_storage = 5
  storage_encrypted = false

  name     = "puppetdb"
  username = "${var.puppetdb_user}"
  password = "${var.puppetdb_pass}"
  port     = "5432"

  vpc_security_group_ids = ["${module.puppetdb_sg.this_security_group_id}"]
  subnet_ids             = ["${module.vpc.public_subnets}"]
  publicly_accessible    = true

  backup_retention_period   = 3
  maintenance_window        = "Mon:00:00-Mon:03:00"
  backup_window             = "03:00-06:00"
  final_snapshot_identifier = "demodb"

  tags = "${var.common_tags}"
}

# Get latest snapshot for PuppetDB
data "aws_db_snapshot" "puppetdb_snapshot" {
  db_instance_identifier = "puppetdb"
  most_recent            = true
}

# PuppetDB Security Group
module "puppetdb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "2.1.0"

  name        = "PuppetDB"
  description = "Security group for the PuppetDB"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_with_cidr_blocks = [
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "149.56.110.113/32"
    },
  ]

  tags = "${var.common_tags}"
}

resource "cloudflare_record" "rds" {
  domain = "ghn.me"
  name   = "rds"
  value  = "${module.puppetdb.this_db_instance_address}"
  type   = "CNAME"
}
