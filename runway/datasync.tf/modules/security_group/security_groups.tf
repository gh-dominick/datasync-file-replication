resource "aws_security_group" "agent-sg" {
  name        = "${var.customer}-${var.env}-${var.application}-agent-sg"
  description = "${var.customer}-${var.env}-${var.application}-agent security group"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "${var.customer}-${var.env}-${var.application}-agent-sg"
    Environment = "${var.env}"
    Application = "${var.application}"
  }
}

resource "aws_security_group" "vpc_ingress" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = tcp
  security_group_id        = "${aws_security_group.agent-sg.name}"
  cidr_blocks              = "${var.vpc_cidr}"
  description              = "Allows VPC resources to connect to Agent"
}
