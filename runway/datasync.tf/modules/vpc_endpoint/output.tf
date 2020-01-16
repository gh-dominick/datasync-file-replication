output "datasync_vpc_endpoint_sg_id" {
  value = "${aws_security_group.vpc-endpoint-sg.id}"
}

output "datasync_vpc_endpoint_sg_name" {
  value = "${aws_security_group.vpc-endpoint-sg.name}"
}

output "vpc_endpoint_id" {
  value = "${aws_vpc_endpoint.vpc-endpoint.id}"
}

output "vpc_endpoint_name" {
  value = "${aws_vpc_endpoint.vpc-endpoint.name}"
}
