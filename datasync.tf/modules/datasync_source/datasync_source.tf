resource "aws_datasync_location_efs" "datasync-source-efs-location" {
  count               = "${var.source_efs_enabled}"
  efs_file_system_arn = "arn:aws:elasticfilesystem:${var.region}:${var.account_id}:file-system/${var.source_efs_id}"
  subdirectory        = "${var.source_subdirectory}"

  ec2_config {
    security_group_arns = ["arn:aws:ec2:${var.region}:${var.account_id}:security-group/${var.agent_security_group_id}","arn:aws:ec2:${var.region}:${var.account_id}:security-group/${var.efs_client_security_group_id}" ]
    subnet_arn          = "arn:aws:ec2:${var.region}:${var.account_id}:subnet/${var.subnet_id}"
  }

  tags {
    Name        = "${var.customer}-${var.env}-datasync-source-efs-location"
    Environment = "${var.env}"
    Application = "datasync-replication"
  }
}

resource "aws_datasync_location_nfs" "datasync-source-nfs-location" {
  count           = "${var.source_nfs_enabled}"
  server_hostname = "${var.source_location_hostname}"
  subdirectory    = "${var.source_subdirectory}"

  on_prem_config {
    agent_arns = ["${var.datasync_agent_arn}"]
  }

  tags {
    Name        = "${var.customer}-${var.env}-datasync-source-nfs-location"
    Environment = "${var.env}"
    Application = "datasync-replication"
  }
}

resource "aws_datasync_location_s3" "datasync-source-s3-location" {
  count         = "${var.source_s3_enabled}"
  s3_bucket_arn = "${var.s3_source_bucket_arn}"
  subdirectory  = "${var.source_subdirectory}"

  s3_config {
    bucket_access_role_arn = "${var.s3_bucket_role_arn}"
  }

  tags {
    Name        = "${var.customer}-${var.env}-datasync-source-s3-location"
    Environment = "${var.env}"
    Application = "datasync-replication"
  }
}
