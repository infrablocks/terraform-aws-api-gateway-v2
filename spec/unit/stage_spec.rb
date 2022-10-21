# frozen_string_literal: true

require 'spec_helper'

describe 'stage' do
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
        vars.api_id =
          output(role: :prerequisites, name: 'api_id')
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'creates a single stage' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
              .once)
    end

    it 'uses the provided stage name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
              .with_attribute_value(:name, stage_name))
    end

    it 'uses a stage description including the component' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
              .with_attribute_value(:description, match(/.*#{component}.*/)))
    end

    it 'uses a stage description including the deployment identifier' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
              .with_attribute_value(
                :description, match(/.*#{deployment_identifier}.*/)
              ))
    end

    it 'auto-deploys the stage' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
              .with_attribute_value(:auto_deploy, true))
    end

    it 'includes the component as a tag' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
              .with_attribute_value(
                :tags, a_hash_including(Component: component)
              ))
    end

    it 'includes the deployment identifier as a tag' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  DeploymentIdentifier: deployment_identifier
                )
              ))
    end
  end

  describe 'when enable_auto_deploy is false' do
    before(:context) do
      @plan = plan(role: :stage) do |vars|
        vars.api_id =
          output(role: :prerequisites, name: 'api_id')
        vars.enable_auto_deploy = false
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'sets auto deploy to false on the stage' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
              .with_attribute_value(:auto_deploy, false))
    end
  end

  describe 'when enable_auto_deploy is true' do
    before(:context) do
      @plan = plan(role: :stage) do |vars|
        vars.api_id =
          output(role: :prerequisites, name: 'api_id')
        vars.enable_auto_deploy = true
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'sets auto deploy to true on the stage' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
              .with_attribute_value(:auto_deploy, true))
    end
  end

  describe 'when tags are provided and include_default_tags is not ' \
           'provided' do
    before(:context) do
      @plan = plan(role: :stage) do |vars|
        vars.api_id =
          output(role: :prerequisites, name: 'api_id')
        vars.tags = { Alpha: 'beta', Gamma: 'delta' }
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
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
      @plan = plan(role: :stage) do |vars|
        vars.api_id =
          output(role: :prerequisites, name: 'api_id')
        vars.tags = { Alpha: 'beta', Gamma: 'delta' }
        vars.include_default_tags = false
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'includes the provided tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
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
        .not_to(include_resource_creation(type: 'aws_apigatewayv2_stage')
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
      @plan = plan(role: :stage) do |vars|
        vars.api_id =
          output(role: :prerequisites, name: 'api_id')
        vars.tags = { Alpha: 'beta', Gamma: 'delta' }
        vars.include_default_tags = true
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
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
      @plan = plan(role: :stage) do |vars|
        vars.api_id =
          output(role: :prerequisites, name: 'api_id')
        vars.include_default_tags = false
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'does not include the default tags' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_apigatewayv2_stage')
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
      @plan = plan(role: :stage) do |vars|
        vars.api_id =
          output(role: :prerequisites, name: 'api_id')
        vars.include_default_tags = true
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'includes the default tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_stage')
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
