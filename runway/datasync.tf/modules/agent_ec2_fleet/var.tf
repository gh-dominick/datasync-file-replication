variable "application" {}
variable "customer"    {}
variable "env"         {}

// Launch Template //
variable "agent_security_group_id"      {}
variable "efs_client_security_group_id" {}
variable "instance_profile"             {}
variable "ssh_key"                      {}
variable "subnet_id"                    {}
variable "userdata"                     {}

variable "all_server_security_group_id"         { default = null }
variable "disable_api_termination"              { default = null }
variable "ebs_optimized"                        { default = true }
variable "instance_initiated_shutdown_behavior" { default = "stop" } # Allowed_values: "stop", "terminate"
variable "instance_type"                        { default = "m5.2xlarge" } # Agent instance must be at least m5.2xlarge in size as of November 2019
variable "kernel_id"                            { default = null }
variable "monitoring_enabled"                   { default = false }
variable "tag_specifications_resource_type"     { default = "instance" } # Allowed_values: "instance", "volume"

variable "image_id" {
  type = "map"
  default = {
    ap-northeast-1 = "ami-083d930199b517fc8"
    ap-northeast-2 = "ami-03d858a112a65b4b0"
    ap-southeast-1 = "ami-0bc229d430d9cd6b6"
    ap-southeast-2 = "ami-0786ddae86abf0362"
    ca-central-1   = "ami-0a17712db83f3f852"
    eu-central-1   = "ami-0b433b5eddaddf1bb"
    eu-west-1      = "ami-031e8db602e4ed16f"
    eu-west-2      = "ami-0036f42661dd3512d"
    eu-west-3      = "ami-00a50aa3d89a1d6c1"
    me-south-1     = "ami-0c563edbfd36aef7f"
    us-east-1      = "ami-08060db92d824f291"
    us-east-2      = "ami-0b350e66c3b082eac"
    us-west-1      = "ami-05d76395fd50e3d80"
    us-west-2      = "ami-01a8854868b5df8da"
  }
}

// EC2 Fleet //
variable "fleet_excess_capacity_termination_policy"  { default = "no-termination" } # Allowed_values: "no-termination", "termination"
variable "fleet_replace_unhealthy_instances"         { default = false }
variable "fleet_terminate_instances"                 { default = false }
variable "fleet_terminate_instances_with_expiration" { default = false }
variable "fleet_type"                                { default = "maintain" } # Allowed_values: "maintain", "request"

variable "fleet_override_availability_zone" { default = null }
variable "fleet_override_instance_type"     { default = null }
variable "fleet_override_max_price"         { default = null }
variable "fleet_override_priority"          { default = null }
variable "fleet_override_subnet_id"         { default = null }
variable "fleet_override_weighted_capacity" { default = null }

variable "fleet_on_demand_options_allocation_strategy" { default = null }

variable "fleet_spot_options_allocation_strategy"            { default = null }
variable "fleet_spot_options_instance_interruption_behavior" { default = null }
variable "fleet_spot_options_instance_pools_to_use_count"    { default = null }

variable "fleet_default_target_capacity_type" { default = "spot" } # Allowed_values: "on-demand", "spot"
variable "fleet_total_target_capacity"        { default = 1 }
variable "fleet_on_demand_target_capacity"    { default = null }
variable "fleet_spot_target_capacity"         { default = null }
