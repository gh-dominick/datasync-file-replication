resource "aws_datasync_agent" "datasync-agent" {
  name = "${var.customer}-${var.env}-datasync-agent"
  ip_address = "${var.agent_instance_ip}"
  tags {
    Name        = "${var.customer}-${var.env}-datasync-agent"
    Environment = "${var.env}"
    Application = "datasync-replication"
  }
}
