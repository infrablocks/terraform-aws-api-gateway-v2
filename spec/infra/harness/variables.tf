variable "region" {}

variable "component" {}
variable "deployment_identifier" {}

variable "protocol_type" {
  default = null
}

variable "enable_execute_api_endpoint" {
  type = bool
  default = null
}
