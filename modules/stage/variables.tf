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

variable "access_logging_log_format" {
  type = string
  description = "The log format to use for access logging."
  default = "{\"accountId\": \"$context.accountId\", \"apiId\": \"$context.apiId\", \"authorizer.error\": \"$context.authorizer.error\", \"authorizer.principalId\": \"$context.authorizer.principalId\", \"awsEndpointRequestId\": \"$context.awsEndpointRequestId\", \"awsEndpointRequestId2\": \"$context.awsEndpointRequestId2\", \"customDomain.basePathMatched\": \"$context.customDomain.basePathMatched\", \"dataProcessed\": $context.dataProcessed, \"domainName\": \"$context.domainName\", \"domainPrefix\": \"$context.domainPrefix\", \"error.message\": \"$context.error.message\", \"error.messageString\": \"$context.error.messageString\", \"error.responseType\": \"$context.error.responseType\", \"extendedRequestId\": \"$context.extendedRequestId\", \"httpMethod\": \"$context.httpMethod\", \"identity.accountId\": \"$context.identity.accountId\", \"identity.caller\": \"$context.identity.caller\", \"identity.cognitoAuthenticationProvider\": \"$context.identity.cognitoAuthenticationProvider\", \"identity.cognitoAuthenticationType\": \"$context.identity.cognitoAuthenticationType\", \"identity.cognitoIdentityId\": \"$context.identity.cognitoIdentityId\", \"identity.cognitoIdentityPoolId\": \"$context.identity.cognitoIdentityPoolId\", \"identity.principalOrgId\": \"$context.identity.principalOrgId\", \"identity.clientCert.clientCertPem\": \"$context.identity.clientCert.clientCertPem\", \"identity.clientCert.subjectDN\": \"$context.identity.clientCert.subjectDN\", \"identity.clientCert.issuerDN\": \"$context.identity.clientCert.issuerDN\", \"identity.clientCert.serialNumber\": \"$context.identity.clientCert.serialNumber\", \"identity.clientCert.validity.notBefore\": \"$context.identity.clientCert.validity.notBefore\", \"identity.clientCert.validity.notAfter\": \"$context.identity.clientCert.validity.notAfter\", \"identity.sourceIp\": \"$context.identity.sourceIp\", \"identity.user\": \"$context.identity.user\", \"identity.userAgent\": \"$context.identity.userAgent\", \"identity.userArn\": \"$context.identity.userArn\", \"integration.error\": \"$context.integration.error\", \"integration.integrationStatus\": $context.integration.integrationStatus, \"integration.latency\": $context.integration.latency, \"integration.requestId\": \"$context.integration.requestId\", \"integration.status\": $context.integration.status, \"integrationErrorMessage\": \"$context.integrationErrorMessage\", \"integrationLatency\": $context.integrationLatency, \"integrationStatus\": $context.integrationStatus, \"path\": \"$context.path\", \"protocol\": \"$context.protocol\", \"requestId\": \"$context.requestId\", \"requestTime\": \"$context.requestTime\", \"requestTimeEpoch\": \"$context.requestTimeEpoch\", \"responseLatency\": $context.responseLatency, \"responseLength\": $context.responseLength, \"routeKey\": \"$context.routeKey\", \"stage\": \"$context.stage\", \"status\": $context.status}"
}
variable "access_logging_log_group_arn" {
  type = string
  description = "The ARN of the CloudWatch log group to use for access logging. Required when `include_access_log_log_group` is `false`."
  default = ""
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to set on created resources."
  default     = {}
}

variable "enable_auto_deploy" {
  type        = bool
  description = "Whether or not to enable auto-deploy for the created stage. Defaults to `true`."
  default     = true
}
variable "enable_access_logging" {
  type        = bool
  description = "Whether or not to enable access logging for the created stage. Defaults to `true`."
  default     = true
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
variable "include_access_logging_log_group" {
  type        = bool
  description = "Whether or not to create a log group for access logging for the created stage. Defaults to `true`."
  default     = true
}
