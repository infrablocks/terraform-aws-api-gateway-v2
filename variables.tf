variable "component" {
  description = "The component for which this API gateway exists."
  type        = string
}
variable "deployment_identifier" {
  description = "An identifier for this instantiation."
  type        = string
}

variable "protocol_type" {
  description = "The API protocol to use for the API gateway. Defaults to \"HTTP\"."
  type        = string
  default     = "HTTP"
}

variable "hosted_zone_id" {
  description = "The ID of the Route 53 hosted zone in which to create DNS records."
  type        = string
  default     = ""
}

variable "default_stage_domain_name" {
  description = "The domain name to map to the API gateway's default stage. Required when both the default stage and default stage domain name are included."
  type        = string
  default     = ""
}
variable "default_stage_domain_name_certificate_arn" {
  description = "The ARN of an AWS managed certificate to use for the default stage domain name. Required when both the default stage and default stage domain name are included."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags to set on created resources."
  type        = map(string)
  default     = {}
}

variable "include_default_tags" {
  description = "Whether or not to include default tags on created resources. Defaults to `true`."
  type        = bool
  default     = true
}
variable "include_default_stage" {
  description = "Whether or not to create a default stage for the API gateway. Defaults to `true`."
  type        = bool
  default     = true
}
variable "include_default_stage_domain_name" {
  description = "Whether or not to create a domain name for the default stage of the API gateway. Only relevant when the default stage is included. Defaults to `true`."
  type        = bool
  default     = true
}
variable "include_default_stage_dns_record" {
  description = "Whether or not to create a DNS record in Route 53 for the domain name of the default stage of the API gateway. Only relevant when both the default stage and default stage domain name are included. Defaults to `true`."
  type        = bool
  default     = true
}
variable "enable_execute_api_endpoint" {
  description = "Whether or not to enable the execute API endpoint on the API gateway. Defaults to `true`."
  type        = bool
  default     = true
}
variable "enable_default_stage_auto_deploy" {
  description = "Whether or not to enable auto-deploy for the created default stage. Only relevant when the default stage is included. Defaults to `true`."
  type        = bool
  default     = true
}

variable "cors_enabled" {
  description = "Enable CORS on the API Gateway"
  type        = bool
  default     = false
}

variable "cors_allow_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_allow_methods" {
  description = "List of allowed HTTP methods for CORS"
  type        = list(string)
  default     = ["GET", "POST", "OPTIONS"]
}

variable "cors_allow_headers" {
  description = "List of allowed headers for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_max_age" {
  description = "CORS max age in seconds"
  type        = number
  default     = 3600
}

variable "cors_allow_credentials" {
  description = "Whether to allow credentials for CORS"
  type        = bool
  default     = false
}

variable "cors_expose_headers" {
  description = "List of exposed headers for CORS"
  type        = list(string)
  default     = []
}