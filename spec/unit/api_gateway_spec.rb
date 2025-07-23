# frozen_string_literal: true

require 'spec_helper'

describe 'API gateway' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'creates an API gateway' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .once)
    end

    it 'includes the component in the name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(:name, match(/.*#{component}.*/)))
    end

    it 'includes the deployment identifier in the name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(
                :name, match(/.*#{deployment_identifier}.*/)
              ))
    end

    it 'includes the component as a tag' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(
                :tags, a_hash_including(Component: component)
              ))
    end

    it 'includes the deployment identifier as a tag' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  DeploymentIdentifier: deployment_identifier
                )
              ))
    end

    it 'uses a protocol type of HTTP' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(:protocol_type, 'HTTP'))
    end

    it 'enables the execute API' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(:disable_execute_api_endpoint, false))
    end

    it 'uses a description including the component' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(:description, match(/.*#{component}.*/)))
    end

    it 'uses a description including the component and deployment ' \
       'identifier' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(
                :description, match(/.*#{deployment_identifier}.*/)
              ))
    end

    it 'does not include CORS configuration' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_apigatewayv2_api')
                  .with_attribute_value(:cors_configuration, anything))
    end

    it 'outputs the API gateway ID' do
      expect(@plan)
        .to(include_output_creation(name: 'api_gateway_id'))
    end

    it 'outputs the API gateway ARN' do
      expect(@plan)
        .to(include_output_creation(name: 'api_gateway_arn'))
    end

    it 'outputs the API gateway name' do
      expect(@plan)
        .to(include_output_creation(name: 'api_gateway_name'))
    end
  end

  describe 'when protocol type is WEBSOCKET' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.protocol_type = 'WEBSOCKET'
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'uses a protocol type of WEBSOCKET' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(:protocol_type, 'WEBSOCKET'))
    end
  end

  describe 'when protocol type is HTTP' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.protocol_type = 'HTTP'
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'uses a protocol type of HTTP' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(:protocol_type, 'HTTP'))
    end
  end

  describe 'when enable_execute_api_endpoint is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.enable_execute_api_endpoint = false
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'disables the execute API' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(:disable_execute_api_endpoint, true))
    end
  end

  describe 'when enable_execute_api_endpoint is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.enable_execute_api_endpoint = true
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'enables the execute API' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(:disable_execute_api_endpoint, false))
    end
  end

  describe 'when tags are provided and include_default_tags is not ' \
           'provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.tags = { Alpha: 'beta', Gamma: 'delta' }
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Component: component,
                  DeploymentIdentifier: deployment_identifier,
                  Alpha: 'beta',
                  Gamma: 'delta'
                )
              ))
    end
  end

  describe 'when tags are provided and include_default_tags is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.tags = { Alpha: 'beta', Gamma: 'delta' }
        vars.include_default_tags = false
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'includes the provided tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Alpha: 'beta',
                  Gamma: 'delta'
                )
              ))
    end

    it 'does not include the default tags' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_apigatewayv2_api')
                  .with_attribute_value(
                    :tags,
                    a_hash_including(
                      Component: component,
                      DeploymentIdentifier: deployment_identifier
                    )
                  ))
    end
  end

  describe 'when tags are provided and include_default_tags is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.tags = { Alpha: 'beta', Gamma: 'delta' }
        vars.include_default_tags = true
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Component: component,
                  DeploymentIdentifier: deployment_identifier,
                  Alpha: 'beta',
                  Gamma: 'delta'
                )
              ))
    end
  end

  describe 'when include_default_tags is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_default_tags = false
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'does not include default tags' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_apigatewayv2_api')
                  .with_attribute_value(
                    :tags,
                    a_hash_including(
                      Component: component,
                      DeploymentIdentifier: deployment_identifier
                    )
                  ))
    end
  end

  describe 'when include_default_tags is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_default_tags = true
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'does not include default tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Component: component,
                  DeploymentIdentifier: deployment_identifier
                )
              ))
    end
  end
end
