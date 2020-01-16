output "datasync-destination-efs-location-id" {
  count = "${var.destination_efs_enabled}"
  value = "${aws_datasync_location_efs.datasync-destination-efs-location.id}"
}

output "datasync-destination-efs-location-arn" {
  count = "${var.destination_efs_enabled}"
  value = "${aws_datasync_location_efs.datasync-destination-efs-location.arn}"
}

output "datasync-destination-nfs-location-id" {
  count = "${var.destination_nfs_enabled}"
  value = "${aws_datasync_location_nfs.datasync-destination-nfs-location.id}"
}

output "datasync-destination-nfs-location-arn" {
  count = "${var.destination_nfs_enabled}"
  value = "${aws_datasync_location_nfs.datasync-destination-nfs-location.arn}"
}

output "datasync-destination-s3-location-id" {
  count = "${var.destination_s3_enabled}"
  value = "${aws_datasync_location_s3.datasync-destination-s3-location.id}"
}

output "datasync-destination-s3-location-arn" {
  count = "${var.destination_s3_enabled}"
  value = "${aws_datasync_location_s3.datasync-destination-s3-location.arn}"
}
