variable "component" {
  description = "The component for which this API gateway exists."
  type        = string
}
variable "deployment_identifier" {
  type        = string
  description = "An identifier for this instantiation."
}

variable "api_id" {
  type        = string
  description = "The ID of the API gateway on which to create the stage."
}
variable "name" {
  type        = string
  description = "The name of the stage to create."
}

variable "hosted_zone_id" {
  type        = string
  description = "The ID of the Route 53 hosted zone in which to create DNS records."
  default     = ""
}

variable "domain_name" {
  type        = string
  description = "The domain name to map to the stage. Required when a domain name is included."
  default     = ""
}
variable "domain_name_certificate_arn" {
  type        = string
  description = "The ARN of an AWS managed certificate to use for the stage domain name. Required when a domain name is included."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to set on created resources."
  default     = {}
}

variable "include_default_tags" {
  type        = bool
  description = "Whether or not to include default tags on created resources. Defaults to `true`."
  default     = true
}
variable "include_domain_name" {
  type        = bool
  description = "Whether or not to create a domain name for the stage. Defaults to `true`."
  default     = true
}
variable "include_dns_record" {
  type        = bool
  description = "Whether or not to create a DNS record in Route 53 for the domain name of the stage. Defaults to `true`."
  default     = true
}
variable "enable_auto_deploy" {
  type        = bool
  description = "Whether or not to enable auto-deploy for the created stage. Defaults to `true`."
  default     = true
}
