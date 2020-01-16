resource "aws_datasync_location_efs" "datasync-destination-efs-location" {
  count               = "${var.destination_efs_enabled}"
  efs_file_system_arn = "arn:aws:elasticfilesystem:${var.region}:${var.account_id}:file-system/${var.destination_efs_id}"
  subdirectory        = "${var.destination_subdirectory}"

  ec2_config {
    security_group_arns = ["arn:aws:ec2:${var.region}:${var.account_id}:security-group/${var.agent_security_group_id}","arn:aws:ec2:${var.region}:${var.account_id}:security-group/${var.efs_client_security_group_id}"]
    subnet_arn          = "arn:aws:ec2:${var.region}:${var.account_id}:subnet/${var.subnet_id}"
  }

  tags {
    Name        = "${var.customer}-${var.env}-datasync-destination-efs-location"
    Environment = "${var.env}"
    Application = "datasync-replication"
  }
}

resource "aws_datasync_location_nfs" "datasync-destination-nfs-location" {
  count           = "${var.destination_nfs_enabled}"
  server_hostname = "${var.destination_location_hostname}"
  subdirectory    = "${var.destination_subdirectory}"

  on_prem_config {
    agent_arns = ["${var.datasync_agent_arn}"]
  }

  tags {
    Name        = "${var.customer}-${var.env}-datasync-destination-nfs-location"
    Environment = "${var.env}"
    Application = "datasync-replication"
  }
}

resource "aws_datasync_location_s3" "datasync-destination-s3-location" {
  count         = "${var.destination_s3_enabled}"
  s3_bucket_arn = "${var.s3_destination_bucket_arn}"
  subdirectory  = "${var.destination_subdirectory}"

  s3_config {
    bucket_access_role_arn = "${var.s3_bucket_role_arn}"
  }

  tags {
    Name        = "${var.customer}-${var.env}-datasync-destination-s3-location"
    Environment = "${var.env}"
    Application = "datasync-replication"
  }
}
