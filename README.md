Terraform AWS API Gateway V2
============================

[![Version](https://img.shields.io/github/v/tag/infrablocks/terraform-aws-api-gateway-v2?label=version&sort=semver)](https://github.com/infrablocks/terraform-aws-api-gateway-v2/tags)
[![Build Pipeline](https://img.shields.io/circleci/build/github/infrablocks/terraform-aws-api-gateway-v2/main?label=build-pipeline)](https://app.circleci.com/pipelines/github/infrablocks/terraform-aws-api-gateway-v2?filter=all)
[![Maintainer](https://img.shields.io/badge/maintainer-go--atomic.io-red)](https://go-atomic.io)

A Terraform module and associated submodules for building an API Gateway
using the V2 API.

The `infrablocks/api-gateway-v2/aws` root module:

* has no prerequisite requirements
* consists of:
    * an API Gateway API
    * an optional default API Gateway stage for the API

Additionally, this module includes 3 submodules:

* `infrablocks/api-gateway-v2/aws//modules/stage` for managing an API
  Gateway stage for the API
* `infrablocks/api-gateway-v2/aws//modules/vpc_link` for managing a VPC link
  for the API
* `infrablocks/api-gateway-v2/aws//modules/log_permissions` for creating and
  configuring a logging role for API Gateway

The `infrablocks/api-gateway-v2/aws//modules/stage` module:

* requires an existing API Gateway API as created by the root module
* consists of:
    * an API Gateway stage
    * a Cloudwatch log group for access logging
    * an optional API Gateway domain name and API mapping
    * an optional DNS record for the configured domain

The `infrablocks/api-gateway-v2/aws//modules/vpc_link` module:

* requires:
    * an existing VPC including subnets
* consists of:
    * an API Gateway VPC link
    * an optional default security group for the VPC link

The `infrablocks/api-gateway-v2/aws//modules/log_permissions` module:

* has no prerequisite requirements
* consists of:
    * an IAM role allowing the API Gateway service to manage Cloudwatch logs
    * configuration of the IAM role against the API Gateway service

Usage
-----

To use the `infrablocks/api-gateway-v2/aws` root module, include something like
the following in your Terraform configuration:

```terraform
module "api_gateway" {
  source  = "infrablocks/api-gateway-v2/aws"
  version = "1.0.0"

  component             = "api-gw"
  deployment_identifier = "production"

  protocol_type = "HTTP"

  default_stage_domain_name                 = "example.com"
  default_stage_domain_name_certificate_arn = "arn:aws:acm:eu-west-2:123456789101:certificate/31bd2209-f35b-4668-b48b-324f44fedc7e"

  hosted_zone_id = "Z0901234DIVFOTMNA324"

  tags = {
    Role: "webhooks"
  }

  providers = {
    aws = aws
    aws.dns = aws
  }
}
```

### CORS Configuration

To enable CORS (Cross-Origin Resource Sharing) on your API Gateway, add the CORS configuration parameters:

```terraform
module "api_gateway" {
  source  = "infrablocks/api-gateway-v2/aws"
  version = "1.0.0"

  component             = "api-gw"
  deployment_identifier = "production"

  protocol_type = "HTTP"

  default_stage_domain_name                 = "example.com"
  default_stage_domain_name_certificate_arn = "arn:aws:acm:eu-west-2:123456789101:certificate/31bd2209-f35b-4668-b48b-324f44fedc7e"

  hosted_zone_id = "Z0901234DIVFOTMNA324"

  # CORS Configuration
  cors_enabled           = true
  cors_allow_origins     = ["https://example.com", "https://app.example.com"]
  cors_allow_methods     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
  cors_allow_headers     = ["Content-Type", "Authorization", "X-Requested-With"]
  cors_max_age           = 7200
  cors_allow_credentials = true
  cors_expose_headers    = ["Content-Type", "Authorization"]

  tags = {
    Role: "webhooks"
  }

  providers = {
    aws = aws
    aws.dns = aws
  }
}
```

**Note:** When `cors_enabled` is set to `true`, the module will automatically configure the API Gateway with the specified CORS settings. The default values are suitable for development but should be customized for production environments:

- `cors_allow_origins`: Defaults to `["*"]` but should be restricted to specific domains in production
- `cors_allow_methods`: Defaults to `["GET", "POST", "OPTIONS"]` but can include additional methods as needed
- `cors_allow_headers`: Defaults to `["*"]` but should be limited to required headers in production
- `cors_max_age`: Controls how long browsers cache preflight responses (default: 3600 seconds)
- `cors_allow_credentials`: Set to `true` when your frontend needs to send cookies or authorization headers
- `cors_expose_headers`: Lists headers that browsers are allowed to access from the response

Then to use the `infrablocks/api-gateway-v2/aws//modules/stage` submodule:

```terraform
module "stage" {
  source  = "infrablocks/api-gateway-v2/aws//modules/stage"
  version = "1.0.0"

  component             = "api-gw"
  deployment_identifier = "production"

  name   = "testing"
  api_id = module.api_gateway.api_gateway_id

  domain_name                 = "example.com"
  domain_name_certificate_arn = "arn:aws:acm:eu-west-2:123456789101:certificate/31bd2209-f35b-4668-b48b-324f44fedc7e"

  hosted_zone_id = "Z0901234DIVFOTMNA324"

  tags = {
    Role: "webhooks"
  }

  providers = {
    aws = aws
    aws.dns = aws.dns
  }
}
```

The `infrablocks/api-gateway-v2/aws//modules/vpc_link` submodule should be used
once per VPC with which AWS Gateway needs to communicate:

```terraform
module "domain" {
  source  = "infrablocks/api-gateway-v2/aws//modules/vpc_link"
  version = "2.0.0"

  component             = "api-gw"
  deployment_identifier = "production"

  vpc_id              = module.base_networking.vpc_id
  vpc_link_subnet_ids = module.base_networking.private_subnet_ids

  tags = {
    Service: "payments"
  }
}
```

The `infrablocks/api-gateway-v2/aws//modules/log_permissions` submodule should be
used once per account, as follows:

```terraform
module "domain" {
  source  = "infrablocks/api-gateway-v2/aws//modules/log_permissions"
  version = "1.0.0"
}
```

See the
[Terraform registry entry](https://registry.terraform.io/modules/infrablocks/api-gateway-v2/aws/latest)
for more details.

### Inputs

#### Root Module

| Name                                        | Description                                                                                                                                                                                          | Default  |                                   Required                                    |
|---------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------:|:-----------------------------------------------------------------------------:|
| `component`                                 | The component for which this API gateway exists.                                                                                                                                                     |    -     |                                      Yes                                      |
| `deployment_identifier`                     | An identifier for this instantiation.                                                                                                                                                                |    -     |                                      Yes                                      |
| `protocol_type`                             | The API protocol to use for the API gateway.                                                                                                                                                         | `"HTTP"` |                                      No                                       |
| `hosted_zone_id`                            | The ID of the Route 53 hosted zone in which to create DNS records.                                                                                                                                   |    -     | If `include_default_stage` and `include_default_stage_dns_record` are `true`  |
| `default_stage_domain_name`                 | The domain name to map to the API gateway's default stage. Required when both the default stage and default stage domain name are included.                                                          |    -     | If `include_default_stage` and `include_default_stage_domain_name` are `true` |
| `default_stage_domain_name_certificate_arn` | The ARN of an AWS managed certificate to use for the default stage domain name. Required when both the default stage and default stage domain name are included.                                     |    -     | If `include_default_stage` and `include_default_stage_domain_name` are `true` |
| `tags`                                      | Additional tags to set on created resources.                                                                                                                                                         |   `{}`   |                                      No                                       |
| `include_default_tags`                      | Whether or not to include default tags on created resources.                                                                                                                                         |  `true`  |                                      No                                       |
| `include_default_stage`                     | Whether or not to create a default stage for the API gateway.                                                                                                                                        |  `true`  |                                      No                                       |
| `include_default_stage_domain_name`         | Whether or not to create a domain name for the default stage of the API gateway. Only relevant when the default stage is included.                                                                   |  `true`  |                                      No                                       |
| `include_default_stage_dns_record`          | Whether or not to create a DNS record in Route 53 for the domain name of the default stage of the API gateway. Only relevant when both the default stage and default stage domain name are included. |  `true`  |                                      No                                       |
| `enable_execute_api_endpoint`               | Whether or not to enable the execute API endpoint on the API gateway.                                                                                                                                |  `true`  |                                      No                                       |
| `enable_default_stage_auto_deploy`          | Whether or not to enable auto-deploy for the created default stage. Only relevant when the default stage is included.                                                                                |  `true`  |                                      No                                       |
| `cors_enabled`                              | Whether to enable CORS on the API Gateway.                                                                                                                                                           | `false`  |                                      No                                       |
| `cors_allow_origins`                        | List of allowed origins for CORS.                                                                                                                                                                    | `["*"]`  |                                      No                                       |
| `cors_allow_methods`                        | List of allowed HTTP methods for CORS.                                                                                                                                                               | `["GET", "POST", "OPTIONS"]` |                          No                                       |
| `cors_allow_headers`                        | List of allowed headers for CORS.                                                                                                                                                                    | `["*"]`  |                                      No                                       |
| `cors_max_age`                              | CORS max age in seconds.                                                                                                                                                                              | `3600`   |                                      No                                       |
| `cors_allow_credentials`                    | Whether to allow credentials for CORS.                                                                                                                                                               | `false`  |                                      No                                       |
| `cors_expose_headers`                       | List of exposed headers for CORS.                                                                                                                                                                    |  `[]`    |                                      No                                       |


#### Stage Sub-module

| Name                               | Description                                                                                                             |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Default                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |                   Required                   |
|------------------------------------|-------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:--------------------------------------------:|
| `component`                        | The component for which this API gateway exists.                                                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       -                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                     Yes                      |
| `deployment_identifier`            | An identifier for this instantiation.                                                                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       -                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                     Yes                      |
| `api_id`                           | The ID of the API gateway on which to create the stage.                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       -                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                     Yes                      |
| `name`                             | The name of the stage to create.                                                                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       -                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                     Yes                      |
| `hosted_zone_id`                   | The ID of the Route 53 hosted zone in which to create DNS records.                                                      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       -                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |      If `include_dns_record` is `true`       |
| `domain_name`                      | The domain name to map to the stage. Required when a domain name is included.                                           |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       -                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |      If `include_domain_name` is `true`      |
| `domain_name_certificate_arn`      | The ARN of an AWS managed certificate to use for the stage domain name. Required when a domain name is included.        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       -                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |      If `include_domain_name` is `true`      |
| `access_logging_log_format`        | The log format to use for access logging.                                                                               | `"{\"accountId\": \"$context.accountId\", \"apiId\": \"$context.apiId\", \"authorizer.claims.property\": \"$context.authorizer.claims.property\", \"authorizer.error\": \"$context.authorizer.error\", \"authorizer.principalId\": \"$context.authorizer.principalId\", \"authorizer.property\": \"$context.authorizer.property\", \"awsEndpointRequestId\": \"$context.awsEndpointRequestId\", \"awsEndpointRequestId2\": \"$context.awsEndpointRequestId2\", \"customDomain.basePathMatched\": \"$context.customDomain.basePathMatched\", \"dataProcessed\": $context.dataProcessed, \"domainName\": \"$context.domainName\", \"domainPrefix\": \"$context.domainPrefix\", \"error.message\": \"$context.error.message\", \"error.messageString\": \"$context.error.messageString\", \"error.responseType\": \"$context.error.responseType\", \"extendedRequestId\": \"$context.extendedRequestId\", \"httpMethod\": \"$context.httpMethod\", \"identity.accountId\": \"$context.identity.accountId\", \"identity.caller\": \"$context.identity.caller\", \"identity.cognitoAuthenticationProvider\": \"$context.identity.cognitoAuthenticationProvider\", \"identity.cognitoAuthenticationType\": \"$context.identity.cognitoAuthenticationType\", \"identity.cognitoIdentityId\": \"$context.identity.cognitoIdentityId\", \"identity.cognitoIdentityPoolId\": \"$context.identity.cognitoIdentityPoolId\", \"identity.principalOrgId\": \"$context.identity.principalOrgId\", \"identity.clientCert.clientCertPem\": \"$context.identity.clientCert.clientCertPem\", \"identity.clientCert.subjectDN\": \"$context.identity.clientCert.subjectDN\", \"identity.clientCert.issuerDN\": \"$context.identity.clientCert.issuerDN\", \"identity.clientCert.serialNumber\": \"$context.identity.clientCert.serialNumber\", \"identity.clientCert.validity.notBefore\": \"$context.identity.clientCert.validity.notBefore\", \"identity.clientCert.validity.notAfter\": \"$context.identity.clientCert.validity.notAfter\", \"identity.sourceIp\": \"$context.identity.sourceIp\", \"identity.user\": \"$context.identity.user\", \"identity.userAgent\": \"$context.identity.userAgent\", \"identity.userArn\": \"$context.identity.userArn\", \"integration.error\": \"$context.integration.error\", \"integration.integrationStatus\": $context.integration.integrationStatus, \"integration.latency\": $context.integration.latency, \"integration.requestId\": \"$context.integration.requestId\", \"integration.status\": $context.integration.status, \"integrationErrorMessage\": \"$context.integrationErrorMessage\", \"integrationLatency\": $context.integrationLatency, \"integrationStatus\": $context.integrationStatus, \"path\": \"$context.path\", \"protocol\": \"$context.protocol\", \"requestId\": \"$context.requestId\", \"requestTime\": \"$context.requestTime\", \"requestTimeEpoch\": \"$context.requestTimeEpoch\", \"responseLatency\": $context.responseLatency, \"responseLength\": $context.responseLength, \"routeKey\": \"$context.routeKey\", \"stage\": \"$context.stage\", \"status\": $context.status}"` |                      No                      |
| `access_logging_log_group_arn`     | The ARN of the CloudWatch log group to use for access logging. Required when `include_access_log_log_group` is `false`. |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       -                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | If `include_access_log_log_group` is `false` |
| `tags`                             | Additional tags to set on created resources.                                                                            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      `{}`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |                      No                      |
| `enable_auto_deploy`               | Whether or not to enable auto-deploy for the created stage.                                                             |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     `true`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |                      No                      |
| `enable_access_logging`            | Whether or not to enable access logging for the created stage.                                                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     `true`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |                      No                      |
| `include_default_tags`             | Whether or not to include default tags on created resources.                                                            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     `true`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |                      No                      |
| `include_domain_name`              | Whether or not to create a domain name for the stage.                                                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     `true`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |                      No                      |
| `include_dns_record`               | Whether or not to create a DNS record in Route 53 for the domain name of the stage.                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     `true`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |                      No                      |
| `include_access_logging_log_group` | Whether or not to create a log group for access logging for the created stage.                                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     `true`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |                      No                      |

#### VPC Link Sub-module

| Name                                      | Description                                                                                       |     Default     | Required |
|-------------------------------------------|---------------------------------------------------------------------------------------------------|:---------------:|:--------:|
| `component`                               | The component for which this VPC link exists.                                                     |        -        |   Yes    |
| `deployment_identifier`                   | An identifier for this instantiation.                                                             |        -        |   Yes    |
| `vpc_id`                                  | The ID of the VPC in which to create the VPC link.                                                |        -        |   Yes    |
| `vpc_link_subnet_ids`                     | The subnet IDs in which to create the VPC link.                                                   |      `[]`       |    No    |
| `vpc_link_default_ingress_cidrs`          | The CIDRs allowed access to the VPC via the VPC link when using the default ingress rule.         | `["0.0.0.0/0"]` |    No    |
| `vpc_link_default_egress_cidrs`           | The CIDRs accessible within the VPC via the VPC link when using the default egress rule.          | `["0.0.0.0/0"]` |    No    |
| `tags`                                    | Additional tags to set on created resources.                                                      |      `{}`       |    No    |
| `include_default_tags`                    | Whether or not to include default tags on created resources.                                      |     `true`      |    No    |
| `include_vpc_link_default_security_group` | Whether or not to create a default security group for the VPC link.                               |     `true`      |    No    |
| `include_vpc_link_default_ingress_rule`   | Whether or not to create the default ingress rule on the security group created for the VPC link. |     `true`      |    No    |
| `include_vpc_link_default_egress_rule`    | Whether or not to create the default egress rule on the security group created for the VPC link.  |     `true`      |    No    |

#### Log Permissions Sub-module

| Name | Description | Default | Required |
|------|-------------|:-------:|:--------:|

### Outputs

#### Root Module

| Name                                      | Description                                                                                                                                                                                                            |
|-------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `api_gateway_id`                          | The ID of the managed API Gateway API.                                                                                                                                                                                 |
| `api_gateway_arn`                         | The ARN of the managed API Gateway API.                                                                                                                                                                                |
| `api_gateway_name`                        | The name of the managed API Gateway API.                                                                                                                                                                               |
| `default_stage_id`                        | The ID of the default stage of the managed API Gateway API. This is an empty string when the default stage is not included.                                                                                            |
| `default_stage_arn`                       | The ARN of the default stage of the managed API Gateway API. This is an empty string when the default stage is not included.                                                                                           |
| `default_stage_api_mapping_id`            | The ID of the API mapping of the default stage of the managed API Gateway API. This is an empty string when the default stage is not included.                                                                         |
| `default_stage_domain_name_id`            | The ID of the domain name of the default stage of the managed API Gateway API. This is an empty string when the default stage is not included or the default stage domain name is not included.                        |
| `default_stage_domain_name_arn`           | The ARN of the domain name of the default stage of the managed API Gateway API. This is an empty string when the default stage is not included or the default stage domain name is not included.                       |
| `default_stage_domain_name_configuration` | The domain name configuration of the domain name of the default stage of the managed API Gateway API. This is an empty string when the default stage is not included or the default stage domain name is not included. |

#### Stage Sub-module

| Name                            | Description                                                                                                                          |
|---------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| `stage_id`                      | The ID of the managed stage.                                                                                                         |
| `stage_arn`                     | The ARN of the managed stage.                                                                                                        |
| `api_mapping_id`                | The ID of the API mapping of the managed stage. This is an empty string when the domain name is not included.                        |
| `domain_name_id`                | The ID of the domain name of the managed stage. This is an empty string when the domain name is not included.                        |
| `domain_name_arn`               | The ARN of the domain name of the managed stage. This is an empty string when the domain name is not included.                       |
| `domain_name_configuration`     | The domain name configuration of the domain name of the managed stage. This is an empty string when the domain name is not included. |
| `access_logging_log_group_arn`  | The ARN of the log group for access logging of the managed stage.                                                                    |
| `access_logging_log_group_name` | The name of the log group for access logging of the managed stage.                                                                   |

#### VPC Link Sub-module

| Name                                 | Description                                                                                                                             |
|--------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| `vpc_link_id`                        | The ID of the managed VPC link.                                                                                                         |
| `vpc_link_default_security_group_id` | The ID of the default security group for the managed VPC link. This is an empty string when the default security group is not included. |

#### Log Permissions Sub-module

| Name                       | Description                                                      |
|----------------------------|------------------------------------------------------------------|
| `logging_role_id`          | The ID of the managed API Gateway logging role.                  |
| `logging_role_arn`         | The ARN of the managed API Gateway logging role.                 |
| `logging_role_name`        | The name of the managed API Gateway logging role.                |
| `logging_role_policy_id`   | The ID of the policy attached to the API Gateway logging role.   |
| `logging_role_policy_name` | The name of the policy attached to the API Gateway logging role. |

### Compatibility

This module is compatible with Terraform versions greater than or equal to
Terraform 1.0 and Terraform AWS provider versions greater than or equal to 4.0.

Development
-----------

### Machine Requirements

In order for the build to run correctly, a few tools will need to be installed
on your development machine:

* Ruby (3.1)
* Bundler
* git
* git-crypt
* gnupg
* direnv
* aws-vault

#### Mac OS X Setup

Installing the required tools is best managed by [homebrew](http://brew.sh).

To install homebrew:

```shell
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Then, to install the required tools:

```shell
# ruby
brew install rbenv
brew install ruby-build
echo 'eval "$(rbenv init - bash)"' >> ~/.bash_profile
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
eval "$(rbenv init -)"
rbenv install 3.3.8
rbenv rehash
rbenv local 3.3.8
gem install bundler

# git, git-crypt, gnupg
brew install git
brew install git-crypt
brew install gnupg

# aws-vault
brew cask install

# direnv
brew install direnv
echo "$(direnv hook bash)" >> ~/.bash_profile
echo "$(direnv hook zsh)" >> ~/.zshrc
eval "$(direnv hook $SHELL)"

direnv allow <repository-directory>
```

### Running the build

Running the build requires an AWS account and AWS credentials. You are free to
configure credentials however you like as long as an access key ID and secret
access key are available. These instructions utilise
[aws-vault](https://github.com/99designs/aws-vault) which makes credential
management easy and secure.

To run the full build, including unit and integration tests, execute:

```shell
aws-vault exec <profile> -- ./go
```

To run the unit tests, execute:

```shell
aws-vault exec <profile> -- ./go test:unit
```

To run the integration tests, execute:

```shell
aws-vault exec <profile> -- ./go test:integration
```

To provision the module prerequisites:

```shell
aws-vault exec <profile> -- ./go deployment:prerequisites:provision[<deployment_identifier>]
```

To provision the module contents:

```shell
aws-vault exec <profile> -- ./go deployment:root:provision[<deployment_identifier>]
```

To destroy the module contents:

```shell
aws-vault exec <profile> -- ./go deployment:root:destroy[<deployment_identifier>]
```

To destroy the module prerequisites:

```shell
aws-vault exec <profile> -- ./go deployment:prerequisites:destroy[<deployment_identifier>]
```

Configuration parameters can be overridden via environment variables. For
example, to run the unit tests with a seed of `"testing"`, execute:

```shell
SEED=testing aws-vault exec <profile> -- ./go test:unit
```

When a seed is provided via an environment variable, infrastructure will not be
destroyed at the end of test execution. This can be useful during development
to avoid lengthy provision and destroy cycles.

To subsequently destroy unit test infrastructure for a given seed:

```shell
FORCE_DESTROY=yes SEED=testing aws-vault exec <profile> -- ./go test:unit
```

### Common Tasks

#### Generating an SSH key pair

To generate an SSH key pair:

```shell
ssh-keygen -m PEM -t rsa -b 4096 -C integration-test@example.com -N '' -f config/secrets/keys/bastion/ssh
```

#### Generating a self-signed certificate

To generate a self signed certificate:

```shell
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365
```

To decrypt the resulting key:

```shell
openssl rsa -in key.pem -out ssl.key
```

#### Managing CircleCI keys

To encrypt a GPG key for use by CircleCI:

```shell
openssl aes-256-cbc \
  -e \
  -md sha1 \
  -in ./config/secrets/ci/gpg.private \
  -out ./.circleci/gpg.private.enc \
  -k "<passphrase>"
```

To check decryption is working correctly:

```shell
openssl aes-256-cbc \
  -d \
  -md sha1 \
  -in ./.circleci/gpg.private.enc \
  -k "<passphrase>"
```

Contributing
------------

Bug reports and pull requests are welcome on GitHub at
https://github.com/infrablocks/terraform-aws-api-gateway-v2.
This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

License
-------

The library is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
