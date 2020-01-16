output "datasync_task_id" {
  value = "${aws_datasync_task.datasync-task.id}"
}

output "datasync_task_arn" {
  value = "${aws_datasync_task.datasync-task.arn}"
}
