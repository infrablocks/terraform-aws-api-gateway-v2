# frozen_string_literal: true

require 'spec_helper'

describe 'VPC link default security group' do
  let(:component) do
    var(role: :vpc_link, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :vpc_link, name: 'deployment_identifier')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :vpc_link) do |vars|
        vars.vpc_id = output(role: :prerequisites, name: 'vpc_id')
        vars.vpc_link_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
      end
    end

    it 'creates a security group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .once)
    end

    it 'creates an ingress rule' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'ingress')
              .once)
    end

    it 'allows ingress access on port 443 from all IP addresses' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'ingress')
              .with_attribute_value(:protocol, 'tcp')
              .with_attribute_value(:from_port, 443)
              .with_attribute_value(:to_port, 443)
              .with_attribute_value(:cidr_blocks, ['0.0.0.0/0'])
              .once)
    end

    it 'creates an egress rule' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'egress')
              .once)
    end

    it 'allows egress access on all ports to all IPs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'egress')
              .with_attribute_value(:protocol, '-1')
              .with_attribute_value(:from_port, -1)
              .with_attribute_value(:to_port, -1)
              .with_attribute_value(:cidr_blocks, ['0.0.0.0/0'])
              .once)
    end
  end

  describe 'when include_vpc_link_default_security_group is false' do
    before(:context) do
      @plan = plan(role: :vpc_link) do |vars|
        vars.include_vpc_link_default_security_group = false
        vars.vpc_id = output(role: :prerequisites, name: 'vpc_id')
        vars.vpc_link_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
      end
    end

    it 'does not create a security group' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_security_group')
                  .once)
    end

    it 'does not create an ingress rule' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_security_group_rule')
                  .with_attribute_value(:type, 'ingress')
                  .once)
    end

    it 'does not create an egress rule' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_security_group_rule')
                  .with_attribute_value(:type, 'egress')
                  .once)
    end
  end

  describe 'when include_vpc_link_default_security_group is true' do
    before(:context) do
      @plan = plan(role: :vpc_link) do |vars|
        vars.include_vpc_link_default_security_group = true
        vars.vpc_id = output(role: :prerequisites, name: 'vpc_id')
        vars.vpc_link_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
      end
    end

    it 'creates a security group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .once)
    end

    it 'creates an ingress rule' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'ingress')
              .once)
    end

    it 'allows ingress access on port 443 from all IP addresses' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'ingress')
              .with_attribute_value(:protocol, 'tcp')
              .with_attribute_value(:from_port, 443)
              .with_attribute_value(:to_port, 443)
              .with_attribute_value(:cidr_blocks, ['0.0.0.0/0'])
              .once)
    end

    it 'creates an egress rule' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'egress')
              .once)
    end

    it 'allows egress access on all ports to all IPs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'egress')
              .with_attribute_value(:protocol, '-1')
              .with_attribute_value(:from_port, -1)
              .with_attribute_value(:to_port, -1)
              .with_attribute_value(:cidr_blocks, ['0.0.0.0/0'])
              .once)
    end
  end

  describe 'when include_vpc_link_default_ingress_rule is false' do
    before(:context) do
      @plan = plan(role: :vpc_link) do |vars|
        vars.include_vpc_link_default_ingress_rule = false
        vars.vpc_id = output(role: :prerequisites, name: 'vpc_id')
        vars.vpc_link_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
      end
    end

    it 'creates a security group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .once)
    end

    it 'does not create an ingress rule' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_security_group_rule')
                  .with_attribute_value(:type, 'ingress'))
    end
  end

  describe 'when include_vpc_link_default_ingress_rule is true' do
    before(:context) do
      @plan = plan(role: :vpc_link) do |vars|
        vars.include_vpc_link_default_ingress_rule = true
        vars.vpc_id = output(role: :prerequisites, name: 'vpc_id')
        vars.vpc_link_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
      end
    end

    it 'creates a security group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .once)
    end

    it 'creates an ingress rule' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'ingress')
              .once)
    end

    it 'allows ingress access on port 443 from all IP addresses' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'ingress')
              .with_attribute_value(:protocol, 'tcp')
              .with_attribute_value(:from_port, 443)
              .with_attribute_value(:to_port, 443)
              .with_attribute_value(:cidr_blocks, ['0.0.0.0/0'])
              .once)
    end
  end

  describe 'when include_vpc_link_default_egress_rule is false' do
    before(:context) do
      @plan = plan(role: :vpc_link) do |vars|
        vars.include_vpc_link_default_egress_rule = false
        vars.vpc_id = output(role: :prerequisites, name: 'vpc_id')
        vars.vpc_link_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
      end
    end

    it 'creates a security group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .once)
    end

    it 'does not create an egress rule' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_security_group_rule')
                  .with_attribute_value(:type, 'egress'))
    end
  end

  describe 'when include_vpc_link_default_egress_rule is true' do
    before(:context) do
      @plan = plan(role: :vpc_link) do |vars|
        vars.include_vpc_link_default_egress_rule = true
        vars.vpc_id = output(role: :prerequisites, name: 'vpc_id')
        vars.vpc_link_subnet_ids =
          output(role: :prerequisites, name: 'private_subnet_ids')
      end
    end

    it 'creates a security group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .once)
    end

    it 'creates an egress rule' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'egress')
              .once)
    end

    it 'allows egress access on all ports to all IPs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'egress')
              .with_attribute_value(:protocol, '-1')
              .with_attribute_value(:from_port, -1)
              .with_attribute_value(:to_port, -1)
              .with_attribute_value(:cidr_blocks, ['0.0.0.0/0'])
              .once)
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
        .to(include_resource_creation(type: 'aws_security_group')
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
        .to(include_resource_creation(type: 'aws_security_group')
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
        .not_to(include_resource_creation(type: 'aws_security_group')
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
        .to(include_resource_creation(type: 'aws_security_group')
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
        .not_to(include_resource_creation(type: 'aws_security_group')
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
        .to(include_resource_creation(type: 'aws_security_group')
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
