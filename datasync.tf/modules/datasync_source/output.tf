output "datasync-source-efs-location-id" {
  count = "${var.source_efs_enabled}"
  value = "${aws_datasync_location_efs.datasync-source-efs-location.id}"
}

output "datasync-source-efs-location-arn" {
  count = "${var.source_efs_enabled}"
  value = "${aws_datasync_location_efs.datasync-source-efs-location.arn}"
}

output "datasync-source-nfs-location-id" {
  count = "${var.source_nfs_enabled}"
  value = "${aws_datasync_location_nfs.datasync-source-nfs-location.id}"
}

output "datasync-source-nfs-location-arn" {
  count = "${var.source_nfs_enabled}"
  value = "${aws_datasync_location_nfs.datasync-source-nfs-location.arn}"
}

output "datasync-source-s3-location-id" {
  count = "${var.source_s3_enabled}"
  value = "${aws_datasync_location_s3.datasync-source-s3-location.id}"
}

output "datasync-source-s3-location-arn" {
  count = "${var.source_s3_enabled}"
  value = "${aws_datasync_location_s3.datasync-source-s3-location.arn}"
}
