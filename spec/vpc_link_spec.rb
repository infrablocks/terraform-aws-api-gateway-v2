# frozen_string_literal: true

require 'spec_helper'

describe 'VPC link' do
  let(:component) { vars(:vpc_link).component }
  let(:deployment_identifier) { vars(:vpc_link).deployment_identifier }

  let(:subnet_ids) do
    output(:prerequisites, 'private_subnet_ids')
  end

  let(:output_vpc_link_id) do
    output(:vpc_link, 'vpc_link_id')
  end

  let(:vpc_links) do
    api_gateway_v2_client.get_vpc_links.items
  end

  let(:created_vpc_link) do
    vpc_links
      .select { |link| link.subnet_ids.to_set == subnet_ids.to_set }
      .reject { |link| link.name =~ /.*provided.*/ }
      .first
  end

  before(:context) do
    provision(:vpc_link) do |vars|
      vars.merge(
        vpc_id: output(:prerequisites, 'vpc_id'),
        vpc_link_subnet_ids:
          output(:prerequisites, 'private_subnet_ids')
      )
    end
  end

  after(:context) do
    destroy(:vpc_link) do |vars|
      vars.merge(
        vpc_id: output(:prerequisites, 'vpc_id'),
        vpc_link_subnet_ids:
          output(:prerequisites, 'private_subnet_ids')
      )
    end
  end

  describe 'by default' do
    it 'creates a VPC link in the subnets with the provided IDs' do
      expect(created_vpc_link).not_to(be_nil)
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'uses a name including the component and deployment identifier' do
      expect(created_vpc_link.name)
        .to(match(/.*#{component}.*/))
      expect(created_vpc_link.name)
        .to(match(/.*#{deployment_identifier}.*/))
    end
    # rubocop:enable RSpec/MultipleExpectations

    it 'outputs the VPC link ID' do
      expect(created_vpc_link.vpc_link_id).to(eq(output_vpc_link_id))
    end

    it 'uses the component and deployment identifier as tags' do
      expect(created_vpc_link.tags)
        .to(eq(
              {
                'Component' => component,
                'DeploymentIdentifier' => deployment_identifier
              }
            ))
    end
  end

  describe 'when tags are provided and include_default_tags is not provided' do
    before(:context) do
      provision(:vpc_link) do |vars|
        vars.merge(
          vpc_id: output(:prerequisites, 'vpc_id'),
          vpc_link_subnet_ids:
            output(:prerequisites, 'private_subnet_ids'),
          tags: { Alpha: 'beta', Gamma: 'delta' }
        )
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(created_vpc_link.tags)
        .to(include(
              {
                'Component' => component,
                'DeploymentIdentifier' => deployment_identifier,
                'Alpha' => 'beta',
                'Gamma' => 'delta'
              }
            ))
    end
  end

  describe 'when tags are provided and include_default_tags is false' do
    before(:context) do
      provision(:vpc_link) do |vars|
        vars.merge(
          vpc_id: output(:prerequisites, 'vpc_id'),
          vpc_link_subnet_ids:
            output(:prerequisites, 'private_subnet_ids'),
          include_default_tags: false,
          tags: { Alpha: 'beta', Gamma: 'delta' }
        )
      end
    end

    it 'includes the provided tags' do
      expect(created_vpc_link.tags)
        .to(include(
              {
                'Alpha' => 'beta',
                'Gamma' => 'delta'
              }
            ))
    end

    it 'does not include the default tags' do
      expect(created_vpc_link.tags)
        .not_to(include(
                  {
                    'Component' => component,
                    'DeploymentIdentifier' => deployment_identifier
                  }
                ))
    end
  end

  describe 'when tags are provided and include_default_tags is true' do
    before(:context) do
      provision(:vpc_link) do |vars|
        vars.merge(
          vpc_id: output(:prerequisites, 'vpc_id'),
          vpc_link_subnet_ids:
            output(:prerequisites, 'private_subnet_ids'),
          include_default_tags: true,
          tags: { Alpha: 'beta', Gamma: 'delta' }
        )
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(created_vpc_link.tags)
        .to(include(
              {
                'Component' => component,
                'DeploymentIdentifier' => deployment_identifier,
                'Alpha' => 'beta',
                'Gamma' => 'delta'
              }
            ))
    end
  end

  describe 'when include_default_tags is false' do
    before(:context) do
      provision(:vpc_link) do |vars|
        vars.merge(
          vpc_id: output(:prerequisites, 'vpc_id'),
          vpc_link_subnet_ids:
            output(:prerequisites, 'private_subnet_ids'),
          include_default_tags: false
        )
      end
    end

    it 'does not include default tags' do
      expect(created_vpc_link.tags)
        .not_to(include(
                  {
                    'Component' => component,
                    'DeploymentIdentifier' => deployment_identifier
                  }
                ))
    end
  end

  describe 'when include_default_tags is true' do
    before(:context) do
      provision(:vpc_link) do |vars|
        vars.merge(
          vpc_id: output(:prerequisites, 'vpc_id'),
          vpc_link_subnet_ids:
            output(:prerequisites, 'private_subnet_ids'),
          include_default_tags: true
        )
      end
    end

    it 'includes default tags' do
      expect(created_vpc_link.tags)
        .to(include(
              {
                'Component' => component,
                'DeploymentIdentifier' => deployment_identifier
              }
            ))
    end
  end
end