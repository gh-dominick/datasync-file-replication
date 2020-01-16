resource "aws_launch_template" "fleet-launch-template" {
  name                                 = "${var.customer}-${var.env}-${var.application}-agent-launch-template"
  description                          = "${var.customer}-${var.env}-${var.application}-agent-launch-template"
  disable_api_termination              = "${var.disable_api_termination}"
  ebs_optimized                        = "${var.ebs_optimized}"
  iam_instance_profile                 = "${var.instance_customer}"
  image_id                             = "${var.image_id}"
  instance_initiated_shutdown_behavior = "${var.instance_initiated_shutdown_behavior}"
  instance_type                        = "${var.instance_type}"
  kernel_id                            = "${var.kernel_id}"
  key_name                             = "${var.ssh_key}"
  userdata                             = "${base64encode(var.userdata)}"

  monitoring {
    enabled = "${var.monitoring_enabled}"
  }

  network_interfaces {
    device_index    = 0
    security_groups = ["${var.agent_security_group_id}","${var.efs_client_security_group_id}","${var.all_server_security_group_id}"]
    subnet_id       = "${var.subnet_id}"
  }

  tag_specifications {
    resource_type = "${var.tag_specifications_resource_type}"

    tags {
      Name        = "${var.customer}-${var.env}-${var.application}-agent"
      Environment = "${var.env}"
      Application = "${var.application}-agent"
    }
  }
}

resource "aws_ec2_fleet" "ec2-fleet" {
  excess_capacity_termination_policy  = "${var.fleet_excess_capacity_termination_policy}"
  replace_unhealthy_instances         = "${var.fleet_replace_unhealthy_instances}"
  terminate_instances                 = "${var.fleet_terminate_instances}"
  terminate_instances_with_expiration = "${var.fleet_terminate_instances_with_expiration}"
  type                                = "${var.fleet_type}"

  launch_template_config {
    launch_template_specification {
      launch_template_id = "${aws_launch_template.datasync-agent-launch-template.id}"
      version            = "${aws_launch_template.datasync-agent-launch-template.latest_version}"
    }

    override {
      availability_zone = "${var.fleet_override_availability_zone}"
      instance_type = "${var.fleet_override_instance_type}"
      max_price = "${var.fleet_override_max_price}"
      priority = "${var.fleet_override_priority}"
      subnet_id = "${var.fleet_override_subnet_id}"
      weighted_capacity = "${var.fleet_override_weighted_capacity}"
    }
  }

  on_demand_options {
    allocation_strategy = "${var.fleet_on_demand_options_allocation_strategy}"
  }

  spot_options {
    allocation_strategy = "${var.fleet_spot_options_allocation_strategy}"
    instance_interruption_behavior = "${var.fleet_spot_options_instance_interruption_behavior}"
    instance_pools_to_use_count = "${var.fleet_spot_options_instance_pools_to_use_count}"
  }

  target_capacity_specification {
    default_target_capacity_type = "${var.fleet_default_target_capacity_type}"
    total_target_capacity        = "${var.fleet_total_target_capacity}"
    on_demand_target_capacity    = "${var.fleet_on_demand_target_capacity}"
    spot_target_capacity         = "${var.fleet_spot_target_capacity}"
  }

  tags {
    Name        = "${var.customer}-${var.env}-${var.application}-agent-fleet"
    Environment = "${var.env}"
    Application = "${var.application}-agent"
  }
}
