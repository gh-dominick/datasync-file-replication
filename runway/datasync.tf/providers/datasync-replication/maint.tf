provider "aws" {
  customer   = "${var.customer}"
  env        = "${var.environment}"
  region     = "${var.region}"
  account_id = "${var.account_id}"
  version    = "~> 2.39"
}

// Security Groups //
module "datasync-security-group" {
  source = "../../modules/security_group"

  application = "datasync"
  customer    = "${var.customer}"
  env         = "${var.environment}"
  vpc_id      = "${var.vpc_id}"
  vpc_cidr    = "${var.vpc_cidr}"
}

// DataSync IAM Roles //
module "datasync-iam-roles" {
  source = "../../modules/iam_roles"

  customer = "${var.customer}"
  env      = "${var.environment}"
}

// DataSync VPC Endpoint //
module "datasync-vpc-endpoint" {
  source = "../../modules/vpc_endpoint"

  application             = "datasync"
  customer                = "${var.customer}"
  env                     = "${var.environment}"
  region                  = "${var.region}"
  agent_security_group_id = "${module.datasync-security-group.datasync_agent_sg_id}"
  subnet_ids              = "${var.subnet_ids}"
  vpc_id                  = "${var.vpc_id}"
}

// Agent EC2 Fleet //
module "datasync-ec2-fleet" {
  source = "../../modules/agent_ec2_fleet"

  application                  = "datasync"
  customer                     = "${var.customer}"
  env                          = "${var.environment}"
  agent_security_group_id      = "${module.datasync-security-group.datasync_agent_sg_id}"
  all_server_security_group_id = "${var.all_server_security_group_id}"
  efs_client_security_group_id = "${var.efs_client_security_group_id}"
  image_id                     = "${var.image_id["${var.region}"]}"
  instance_profile             = "${module.datasync-iam-roles.datasync-agent-instance-profile-name}"
  ssh_key                      = "${var.ssh_key}"
  subnet_id                    = "${var.subnet_id}"
  userdata                     = "${local.datasync-agent-userdata}"
}

// DataSync Agent //
module "datasync-agent" {
  source = "../../modules/datasync_agent"

  customer          = "${var.customer}"
  env               = "${var.environment}"
  agent_instance_ip = ""
}

// EFS Source Location //
module "datasync-source" {
  source = "../../modules/datasync_source"

  customer                     = "${var.customer}"
  env                          = "${var.environment}"
  source_efs_enabled           = 1
  account_id                   = "${var.account_id}"
  agent_security_group_id      = "${module.datasync-security-group.datasync_agent_sg_id}"
  efs_client_security_group_id = "${var.efs_client_security_group_id}"
  region                       = "${var.region}"
  source_efs_id                = "${var.source_efs_id}"
  subnet_id                    = "${var.subnet_id}"
}

// NFS Destination Location //
module "datasync-destination" {
  source = "../../modules/datasync_destination"

  customer                      = "${var.customer}"
  env                           = "${var.environment}"
  destination_nfs_enabled       = 1
  destination_location_hostname = "${var.destination_location_hostname}"
  datasync_agent_arn            = "${module.datasync-agent.datasync-agent-arn}"
}

// EFS to NFS DataSync Task //
module "datasync-task" {
  source = "../../modules/datasync_task"

  customer                          = "${var.customer}"
  env                               = "${var.environment}"
  datasync_destination_location_arn = "${module.datasync-destination.datasync-destination-nfs-location-arn}"
  datasync_source_location_arn      = "${module.datasync-source.datasync-source-efs-location-arn}"
}
