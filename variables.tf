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

variable "include_default_stage" {
  type        = bool
  description = "Whether or not to create a default stage for the API gateway. Defaults to `true`."
  default     = true
}
variable "enable_execute_api_endpoint" {
  type        = bool
  description = "Whether or not to enable the execute API endpoint on the API gateway. Defaults to `true`."
  default     = true
}
variable "enable_auto_deploy_for_default_stage" {
  type    = bool
  description = "Whether or not to enable auto-deploy for the created default stage. Only relevant when the default stage is included. Defaults to `true`."
  default = true
}
