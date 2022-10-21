# frozen_string_literal: true

require 'spec_helper'

describe 'default stage domain name' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end
  let(:default_stage_domain_name_certificate_arn) do
    output(role: :prerequisites, name: 'certificate_arn')
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

    it 'creates a domain name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
              .once)
    end

    it 'creates a mapping for the domain name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api_mapping')
              .once)
    end

    it 'uses the provided certificate ARN' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
              .with_attribute_value(
                [:domain_name_configuration, 0, :certificate_arn],
                default_stage_domain_name_certificate_arn
              ))
    end

    it 'uses an endpoint type of REGIONAL' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
              .with_attribute_value(
                [:domain_name_configuration, 0, :endpoint_type],
                'REGIONAL'
              ))
    end

    it 'uses a security policy of TLS_1_2' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
              .with_attribute_value(
                [:domain_name_configuration, 0, :security_policy],
                'TLS_1_2'
              ))
    end

    it 'includes the component as a tag' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
              .with_attribute_value(
                :tags, a_hash_including(Component: component)
              ))
    end

    it 'includes the deployment identifier as a tag' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  DeploymentIdentifier: deployment_identifier
                )
              ))
    end
  end

  describe 'when include_default_stage_domain_name is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        # vars.hosted_zone_id =
        #   output(role: :prerequisites, name: 'public_zone_id')
        vars.include_default_stage_domain_name = false
      end
    end

    it 'does not create a domain name' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_apigatewayv2_domain_name'))
    end

    it 'does not create a mapping for the domain name' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_apigatewayv2_api_mapping'))
    end
  end

  describe 'when include_default_stage_domain_name is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_default_stage_domain_name = true
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'creates a domain name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
              .once)
    end

    it 'creates a mapping for the domain name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_api_mapping')
              .once)
    end

    it 'uses the provided certificate ARN' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
              .with_attribute_value(
                [:domain_name_configuration, 0, :certificate_arn],
                default_stage_domain_name_certificate_arn
              ))
    end

    it 'uses an endpoint type of REGIONAL' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
              .with_attribute_value(
                [:domain_name_configuration, 0, :endpoint_type],
                'REGIONAL'
              ))
    end

    it 'uses a security policy of TLS_1_2' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
              .with_attribute_value(
                [:domain_name_configuration, 0, :security_policy],
                'TLS_1_2'
              ))
    end

    it 'includes the component as a tag' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
              .with_attribute_value(
                :tags, a_hash_including(Component: component)
              ))
    end

    it 'includes the deployment identifier as a tag' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  DeploymentIdentifier: deployment_identifier
                )
              ))
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
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
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
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
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
        .not_to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
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
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
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

    it 'does not include the default tags' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
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

    it 'includes the default tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_domain_name')
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
