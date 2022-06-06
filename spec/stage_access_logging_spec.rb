# frozen_string_literal: true

require 'spec_helper'

describe 'stage domain name' do
  let(:component) { vars(:stage).component }
  let(:deployment_identifier) { vars(:stage).deployment_identifier }

  let(:stage_name) { vars(:stage).name }

  let(:api_id) do
    output(:prerequisites, 'api_id')
  end

  let(:output_stage_id) do
    output(:stage, 'stage_id')
  end

  let(:output_access_logging_log_group_arn) do
    output(:stage, 'access_logging_log_group_arn')
  end

  let(:output_access_logging_log_group_name) do
    output(:stage, 'access_logging_log_group_name')
  end

  let(:api_gateway_stages) do
    api_gateway_v2_client.get_stages(api_id:).items
  end

  let(:api_gateway_stage) do
    api_gateway_stages[0]
  end

  before(:context) do
    provision(:stage) do |vars|
      vars.merge(
        api_id: output(:prerequisites, 'api_id'),
        include_domain_name: false
      )
    end
  end

  after(:context) do
    destroy(:stage) do |vars|
      vars.merge(
        api_id: output(:prerequisites, 'api_id'),
        include_domain_name: false
      )
    end
  end

  describe 'by default' do
    it 'enables access logging' do
      expect(api_gateway_stage.access_log_settings).not_to(be_nil)
    end

    it 'creates a log group for the access logs' do
      expect(cloudwatch_logs(output_access_logging_log_group_name)).to(exist)
    end

    it 'includes the component in the log group name' do
      expect(output_access_logging_log_group_name)
        .to(match(/.*#{component}.*/))
    end

    it 'includes the deployment identifier in the log group name' do
      expect(output_access_logging_log_group_name)
        .to(match(/.*#{deployment_identifier}.*/))
    end

    it 'includes the stage name in the log group name' do
      expect(output_access_logging_log_group_name)
        .to(match(/.*#{stage_name}.*/))
    end

    it 'uses the created log group to store access logs' do
      expect(api_gateway_stage.access_log_settings.destination_arn)
        .to(eq(output_access_logging_log_group_arn))
    end

    # rubocop:disable RSpec/ExampleLength
    it 'logs everything' do
      expect(api_gateway_stage.access_log_settings.format)
        .to(eq(
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
