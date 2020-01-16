resource "aws_datasync_task" "datasync-task" {
  name                     = "${var.customer}-${var.env}-datasync-task"
  destination_location_arn = "${var.datasync_destination_location_arn}"
  source_location_arn      = "${var.datasync_source_location_arn}"

  options {
    atime                  = "${var.datasync_options_atime}"
    bytes_per_second       = "${var.datasync_options_bytes_per_second}"
    gid                    = "${var.datasync_options_gid}"
    mtime                  = "${var.datasync_options_mtime}"
    posix_permissions      = "${var.datasync_options_posix_permissions}"
    preserve_deleted_files = "${var.datasync_options_preserve_deleted_files}"
    preserve_devices       = "${var.datasync_options_preserve_devices}"
    uid                    = "${var.datasync_options_uid}"
    verify_mode            = "${var.datasync_options_verify_mode}"
  }

  tags {
    Name        = "${var.customer}-${var.env}-datasync-task"
    Environment = "${var.env}"
    Application = "datasync-replication"
  }
}
