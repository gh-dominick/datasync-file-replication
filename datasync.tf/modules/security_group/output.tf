output "datasync_agent_sg_id" {
  value = "${aws_security_group.agent-sg.id}"
}

output "datasync_agent_sg_name" {
  value = "${aws_security_group.agent-sg.name}"
}
