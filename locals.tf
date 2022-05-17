locals {
  # default for cases when `null` value provided, meaning "use default"
  protocol_type               = var.protocol_type == null ? "HTTP" : var.protocol_type
  enable_execute_api_endpoint = var.enable_execute_api_endpoint == null ? true : var.enable_execute_api_endpoint
}
