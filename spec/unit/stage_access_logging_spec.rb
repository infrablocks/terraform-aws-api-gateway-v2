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

    it 'logs everything' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
              .with_attribute_value(
                [:access_log_settings, 0, :format],
                '{' \
                '"apiId": "$context.apiId",' \
                '"requestId": "$context.requestId",' \
                '"extendedRequestId": "$context.extendedRequestId",' \
                '"httpMethod": "$context.httpMethod",' \
                '"path": "$context.path",' \
                '"protocol": "$context.protocol",' \
                '"requestTime": "$context.requestTime",' \
                '"requestTimeEpoch": "$context.requestTimeEpoch",' \
                '"status": $context.status,' \
                '"responseLatency": $context.responseLatency,' \
                '"responseLength": $context.responseLength' \
                '}'
              ))
    end
  end
end
