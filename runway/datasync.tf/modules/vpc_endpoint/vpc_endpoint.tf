resource "aws_security_group" "vpc-endpoint-sg" {
  name          = "${var.customer}-${var.env}-${var.application}-vpce-sg"
  description   = "${var.customer}-${var.env}-${var.application}-vpce security group"
  vpc_id        = "${var.vpc_id}"

  tags {
    Name        = "${var.customer}-${var.env}-${var.application}-vpce-sg"
    Environment = "${var.env}"
    Application = "${var.application}"
  }
}

resource "aws_vpc_endpoint" "vpc-endpoint" {
  name                = "${var.customer}-${var.env}-${var.application}-vpc-endpoint"
  private_dns_enabled = "${var.private_dns_enabled}"
  security_group_ids  = ["${aws_security_group.vpc-endpoint-sg.id}"]
  service_name        = "com.amazonaws.${var.region}.${var.endpoint_service_name}"
  subnet_ids          = ["${element(var.subnet_ids, 0)}","${element(var.subnet_ids, 1)}"]
  vpc_endpoint_type   = "${var.vpc_endpoint_type}"
  vpc_id              = "${var.vpc_id}"
}

resource "aws_security_group_rule" "agent-datasync-ingress" {
  type                     = "ingress"
  from_port                = 1024
  to_port                  = 1064
  protocol                 = tcp
  security_group_id        = "${aws_security_group.vpc-endpoint-sg.name}"
  source_security_group_id = "${var.agent_security_group_id}"
  description              = "Allows Agent connection to VPC Endpoint"
}

resource "aws_security_group_rule" "agent-https-ingress" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = tcp
  security_group_id        = "${aws_security_group.vpc-endpoint-sg.name}"
  source_security_group_id = "${var.agent_security_group_id}"
  description              = "Allows Agent activation connection to VPC Endpoint"
}
