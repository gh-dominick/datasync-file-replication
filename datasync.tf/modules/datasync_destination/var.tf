variable "customer" {}
variable "env"      {}


variable "destination_subdirectory" { default = "/" }

// EFS Destination //
variable "destination_efs_enabled"      { default = 0 }
variable "account_id"                   { default = null }
variable "agent_security_group_id"      { default = null }
variable "destination_efs_id"           { default = null }
variable "efs_client_security_group_id" { default = null }
variable "region"                       { default = null }
variable "subnet_id"                    { default = null }

// NFS Destination //
variable "destination_nfs_enabled"       { default = 0 }
variable "destination_location_hostname" { default = null }
variable "datasync_agent_arn"            { default = null }

// S3 Destination //
variable "destination_s3_enabled"    { default = 0 }
variable "s3_destination_bucket_arn" { default = null }
variable "s3_bucket_role_arn"        { default = null }
