variable "region" {}

variable "component" {}
variable "deployment_identifier" {}

variable "api_id" {}
variable "name" {}

variable "hosted_zone_id" {
  default = null
}
variable "domain_name" {
  default = null
}
variable "domain_name_certificate_arn" {
  default = null
}

variable "tags" {
  type    = map(string)
  default = null
}

variable "include_default_tags" {
  type    = bool
  default = null
}
variable "include_domain_name" {
  type    = bool
  default = null
}
variable "include_dns_record" {
  type    = bool
  default = null
}
variable "enable_auto_deploy" {
  type    = bool
  default = null
}
