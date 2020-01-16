variable "customer" {}
variable "env"      {}

variable "source_subdirectory" { default = "/" }

// EFS Source //
variable "source_efs_enabled"           { default = 0 }
variable "account_id"                   { default = null }
variable "agent_security_group_id"      { default = null }
variable "efs_client_security_group_id" { default = null }
variable "region"                       { default = null }
variable "source_efs_id"                { default = null }
variable "subnet_id"                    { default = null }

// NFS Source //
variable "source_nfs_enabled"       { default = 0 }
variable "datasync_agent_arn"       { default = null }
variable "source_location_hostname" { default = null }


// S3 Source //
variable "source_s3_enabled"    { default = 0 }
variable "s3_bucket_role_arn"   { default = null }
variable "s3_source_bucket_arn" { default = null }
