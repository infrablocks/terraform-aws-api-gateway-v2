variable "component" {
  description = "The component for which this API gateway exists."
  type        = string
}
variable "deployment_identifier" {
  type        = string
  description = "An identifier for this instantiation."
}

variable "protocol_type" {
  type        = string
  description = "The API protocol to use for the API gateway. Defaults to \"HTTP\"."
  default     = "HTTP"
}

variable "default_stage_domain_name" {
  type = string
  description = "The domain name to map to the API gateway's default stage. Required when both the default stage and default stage domain name are included."
  default = ""
}
variable "default_stage_domain_name_certificate_arn" {
  type = string
  description = "The ARN of an AWS managed certificate to use for the default stage domain name. Required when both the default stage and default stage domain name are included."
  default = ""
}

variable "include_default_stage" {
  type        = bool
  description = "Whether or not to create a default stage for the API gateway. Defaults to `true`."
  default     = true
}
variable "include_default_stage_domain_name" {
  type        = bool
  description = "Whether or not to create a domain name for the default stage of the API gateway. Only relevant when the default stage is included. Defaults to `true`."
  default     = true
}
variable "enable_execute_api_endpoint" {
  type        = bool
  description = "Whether or not to enable the execute API endpoint on the API gateway. Defaults to `true`."
  default     = true
}
variable "enable_default_stage_auto_deploy" {
  type    = bool
  description = "Whether or not to enable auto-deploy for the created default stage. Only relevant when the default stage is included. Defaults to `true`."
  default = true
}
