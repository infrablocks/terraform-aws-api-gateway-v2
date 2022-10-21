# frozen_string_literal: true

require 'spec_helper'

RSpec::Matchers.define_negated_matcher(
  :a_non_nil_value, :a_nil_value
)

describe 'stage access logging' do
  let(:component) do
    var(role: :stage, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :stage, name: 'deployment_identifier')
  end
  let(:stage_name) do
    var(role: :stage, name: 'name')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :stage) do |vars|
        vars.api_id = output(role: :prerequisites, name: 'api_id')
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'enables access logging' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
              .with_attribute_value(:access_log_settings, a_non_nil_value))
    end

    it 'creates a log group for the access logs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_cloudwatch_log_group')
              .once)
    end

    it 'includes the component in the log group name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_cloudwatch_log_group')
              .with_attribute_value(:name, match(/.*#{component}.*/)))
    end

    it 'includes the deployment identifier in the log group name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_cloudwatch_log_group')
              .with_attribute_value(
                :name, match(/.*#{deployment_identifier}.*/)
              ))
    end

    it 'includes the stage name in the log group name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_cloudwatch_log_group')
              .with_attribute_value(
                :name, match(/.*#{stage_name}.*/)
              ))
    end

    # rubocop:disable RSpec/ExampleLength
    it 'logs everything' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
              .with_attribute_value(
                [:access_log_settings, 0, :format],
                '{' \
                '"accountId": "$context.accountId", ' \
                '"apiId": "$context.apiId", ' \
                '"authorizer.claims.property": ' \
                '"$context.authorizer.claims.property", ' \
                '"authorizer.error": "$context.authorizer.error", ' \
                '"authorizer.principalId": ' \
                '"$context.authorizer.principalId", ' \
                '"authorizer.property": "$context.authorizer.property", ' \
                '"awsEndpointRequestId": ' \
                '"$context.awsEndpointRequestId", ' \
                '"awsEndpointRequestId2": ' \
                '"$context.awsEndpointRequestId2", ' \
                '"customDomain.basePathMatched": ' \
                '"$context.customDomain.basePathMatched", ' \
                '"dataProcessed": $context.dataProcessed, ' \
                '"domainName": "$context.domainName", ' \
                '"domainPrefix": "$context.domainPrefix", ' \
                '"error.message": "$context.error.message", ' \
                '"error.messageString": "$context.error.messageString", ' \
                '"error.responseType": "$context.error.responseType", ' \
                '"extendedRequestId": "$context.extendedRequestId", ' \
                '"httpMethod": "$context.httpMethod", ' \
                '"identity.accountId": "$context.identity.accountId", ' \
                '"identity.caller": "$context.identity.caller", ' \
                '"identity.cognitoAuthenticationProvider": ' \
                '"$context.identity.cognitoAuthenticationProvider", ' \
                '"identity.cognitoAuthenticationType": ' \
                '"$context.identity.cognitoAuthenticationType", ' \
                '"identity.cognitoIdentityId": ' \
                '"$context.identity.cognitoIdentityId", ' \
                '"identity.cognitoIdentityPoolId": ' \
                '"$context.identity.cognitoIdentityPoolId", ' \
                '"identity.principalOrgId": ' \
                '"$context.identity.principalOrgId", ' \
                '"identity.clientCert.clientCertPem": ' \
                '"$context.identity.clientCert.clientCertPem", ' \
                '"identity.clientCert.subjectDN": ' \
                '"$context.identity.clientCert.subjectDN", ' \
                '"identity.clientCert.issuerDN": ' \
                '"$context.identity.clientCert.issuerDN", ' \
                '"identity.clientCert.serialNumber": ' \
                '"$context.identity.clientCert.serialNumber", ' \
                '"identity.clientCert.validity.notBefore": ' \
                '"$context.identity.clientCert.validity.notBefore", ' \
                '"identity.clientCert.validity.notAfter": ' \
                '"$context.identity.clientCert.validity.notAfter", ' \
                '"identity.sourceIp": "$context.identity.sourceIp", ' \
                '"identity.user": "$context.identity.user", ' \
                '"identity.userAgent": "$context.identity.userAgent", ' \
                '"identity.userArn": "$context.identity.userArn", ' \
                '"integration.error": "$context.integration.error", ' \
                '"integration.integrationStatus": ' \
                '$context.integration.integrationStatus, ' \
                '"integration.latency": $context.integration.latency, ' \
                '"integration.requestId": ' \
                '"$context.integration.requestId", ' \
                '"integration.status": $context.integration.status, ' \
                '"integrationErrorMessage": ' \
                '"$context.integrationErrorMessage", ' \
                '"integrationLatency": $context.integrationLatency, ' \
                '"integrationStatus": $context.integrationStatus, ' \
                '"path": "$context.path", ' \
                '"protocol": "$context.protocol", ' \
                '"requestId": "$context.requestId", ' \
                '"requestTime": "$context.requestTime", ' \
                '"requestTimeEpoch": "$context.requestTimeEpoch", ' \
                '"responseLatency": $context.responseLatency, ' \
                '"responseLength": $context.responseLength, ' \
                '"routeKey": "$context.routeKey", ' \
                '"stage": "$context.stage", ' \
                '"status": $context.status' \
                '}'
              ))
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
