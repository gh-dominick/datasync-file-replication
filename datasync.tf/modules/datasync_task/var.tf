variable "customer" {}
variable "env" {}

variable "datasync_destination_location_arn" {}
variable "datasync_source_location_arn" {}

variable "datasync_options_atime"                  { defaul = "BEST_EFFORT" } # Allowed_values: "BEST_EFFORT", "NONE"
variable "datasync_options_bytes_per_second"       { default = "-1" }
variable "datasync_options_gid"                    { default = "INT_VALUE" } # Allowed_values: "BOTH", "INT_VALUE", "NAME", "NONE"
variable "datasync_options_mtime"                  { default = "PRESERVE" } # Allowed_values: "NONE", "PRESERVE"
variable "datasync_options_posix_permissions"      { default = "PRESERVE" } # Allowed_values: "NONE", "PRESERVE"
variable "datasync_options_preserve_deleted_files" { default = "REMOVE" } # Allowed_values: "PRESERVE", "REMOVE"
variable "datasync_options_preserve_devices"       { default = "PRESERVE" } # Allowed_values: "NONE", "PRESERVE"
variable "datasync_options_uid"                    { default = "INT_VALUE" } # Allowed_values: "BOTH", "INT_VALUE", "NAME", "NONE"
variable "datasync_options_verify_mode"            { default = "POINT_IN_TIME_CONSISTENT" } # Allowed_values: "NONE", "POINT_IN_TIME_CONSISTENT"
