output "datasync-agent-launch-template-name" {
  value = "${aws_launch_template.fleet-launch-template.name}"
}

output "datasync-agent-launch-template-id" {
  value = "${aws_launch_template.fleet-launch-template.id}"
}

output "datasync-agent-fleet-id" {
  value = "${aws_ec2_fleet.ec2-fleet.id}"
}
