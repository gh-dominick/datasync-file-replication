variable "application" {}
variable "customer"    {}
variable "env"         {}
variable "region"      {}

variable "agent_security_group_id" {}
variable "subnet_ids"              {}
variable "vpc_id"                  {}

variable "endpoint_service_name" { default = "datasync" }
variable "private_dns_enabled"   { default = true }
variable "vpc_endpoint_type"     { default = "Interface"} # Allowed_values: "Gateway", "Interface"
