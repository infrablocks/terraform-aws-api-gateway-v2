# frozen_string_literal: true

require 'spec_helper'

describe 'VPC link' do
  let(:component) do
    var(role: :vpc_link, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :vpc_link, name: 'deployment_identifier')
  end
  let(:vpc_link_subnet_ids) do
    output(role: :prerequisites, name: 'private_subnet_ids')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :vpc_link) do |vars|
        vars.vpc_id = output(role: :prerequisites, name: 'vpc_id')
        vars.vpc_link_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
      end
    end

    it 'creates a VPC link' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_vpc_link')
              .once)
    end

    it 'uses the provided subnet IDs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_vpc_link')
              .with_attribute_value(
                :subnet_ids, contain_exactly(*vpc_link_subnet_ids)
              ))
    end

    it 'includes the component in the VPC link name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_vpc_link')
              .with_attribute_value(:name, match(/.*#{component}.*/)))
    end

    it 'includes the deployment identifier in the VPC link name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_vpc_link')
              .with_attribute_value(
                :name, match(/.*#{deployment_identifier}.*/)
              ))
    end

    it 'outputs the VPC link ID' do
      expect(@plan)
        .to(include_output_creation(name: 'vpc_link_id'))
    end

    it 'includes the component as a tag' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_vpc_link')
              .with_attribute_value(
                :tags, a_hash_including(Component: component)
              ))
    end

    it 'includes the deployment identifier as a tag' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_vpc_link')
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
      @plan = plan(role: :vpc_link) do |vars|
        vars.tags = { Alpha: 'beta', Gamma: 'delta' }
        vars.vpc_id = output(role: :prerequisites, name: 'vpc_id')
        vars.vpc_link_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_vpc_link')
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
      @plan = plan(role: :vpc_link) do |vars|
        vars.tags = { Alpha: 'beta', Gamma: 'delta' }
        vars.include_default_tags = false
        vars.vpc_id = output(role: :prerequisites, name: 'vpc_id')
        vars.vpc_link_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
      end
    end

    it 'includes the provided tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_vpc_link')
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
        .not_to(include_resource_creation(type: 'aws_apigatewayv2_vpc_link')
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
      @plan = plan(role: :vpc_link) do |vars|
        vars.tags = { Alpha: 'beta', Gamma: 'delta' }
        vars.include_default_tags = true
        vars.vpc_id = output(role: :prerequisites, name: 'vpc_id')
        vars.vpc_link_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_vpc_link')
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
      @plan = plan(role: :vpc_link) do |vars|
        vars.include_default_tags = false
        vars.vpc_id = output(role: :prerequisites, name: 'vpc_id')
        vars.vpc_link_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
      end
    end

    it 'does not include the default tags' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_apigatewayv2_vpc_link')
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
      @plan = plan(role: :vpc_link) do |vars|
        vars.include_default_tags = true
        vars.vpc_id = output(role: :prerequisites, name: 'vpc_id')
        vars.vpc_link_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
      end
    end

    it 'includes the default tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_apigatewayv2_vpc_link')
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
