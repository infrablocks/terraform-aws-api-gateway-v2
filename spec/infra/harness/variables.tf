variable "region" {}

variable "component" {}
variable "deployment_identifier" {}

variable "protocol_type" {
  default = null
}

variable "default_stage_domain_name" {
  default = null
}
variable "default_stage_domain_name_certificate_arn" {
  default = null
}

variable "include_default_stage" {
  type    = bool
  default = null
}
variable "include_default_stage_domain_name" {
  type    = bool
  default = null
}
variable "enable_execute_api_endpoint" {
  type    = bool
  default = null
}
variable "enable_default_stage_auto_deploy" {
  type    = bool
  default = null
}
