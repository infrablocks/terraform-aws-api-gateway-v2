variable "region" {}

variable "component" {}
variable "deployment_identifier" {}

variable "protocol_type" {
  default = null
}

variable "include_default_stage" {
  type    = bool
  default = null
}
variable "enable_execute_api_endpoint" {
  type    = bool
  default = null
}
variable "enable_auto_deploy_for_default_stage" {
  type    = bool
  default = null
}
