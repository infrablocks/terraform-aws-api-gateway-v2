variable "region" {}

variable "component" {}
variable "deployment_identifier" {}

variable "domain_name" {}
variable "public_zone_id" {}

variable "cors_enabled" {
  description = "Enable CORS on the API Gateway"
  type        = bool
}

variable "cors_allow_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
}

variable "cors_allow_methods" {
  description = "List of allowed HTTP methods for CORS"
  type        = list(string)
}

variable "cors_allow_headers" {
  description = "List of allowed headers for CORS"
  type        = list(string)
}

variable "cors_max_age" {
  description = "CORS max age in seconds"
  type        = number
}

variable "cors_allow_credentials" {
  description = "Whether to allow credentials for CORS"
  type        = bool
}

variable "cors_expose_headers" {
  description = "List of exposed headers for CORS"
  type        = list(string)
}