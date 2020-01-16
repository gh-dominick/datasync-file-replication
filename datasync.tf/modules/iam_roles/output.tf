output "datasync-task-execution-role-name" {
  value = "${aws_iam_role.datasync-task-execution-role.name}"
}

output "datasync-task-execution-role-arn" {
  value = "${aws_iam_role.datasync-task-execution-role.arn}"
}

output "datasync-agent-role-name" {
  value = "${aws_iam_role.datasync-agent-role.name}"
}

output "datasync-agent-role-arn" {
  value = "${aws_iam_role.datasync-agent-role.arn}"
}

output "datasync-agent-policy-name" {
  value = "${aws_iam_policy.datasync-agent-policy.name}"
}

output "datasync-agent-policy-arn" {
  value = "${aws_iam_policy.datasync-agent-policy.arn}"
}

output "datasync-agent-instance-profile-name" {
  value = "${aws_iam_instance_profile.datasync-agent-instance-profile.name}"
}
