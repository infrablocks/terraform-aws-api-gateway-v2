# frozen_string_literal: true

require 'spec_helper'

describe 'stage domain name' do
  let(:component) { vars(:stage).component }
  let(:deployment_identifier) { vars(:stage).deployment_identifier }

  let(:hosted_zone_id) { configuration.public_zone_id }

  let(:api_id) do
    output(:prerequisites, 'api_id')
  end

  let(:output_api_mapping_id) do
    output(:stage, 'api_mapping_id')
  end

  let(:domain_name_certificate_arn) do
    output(:prerequisites, 'certificate_arn')
  end

  let(:domain_name) do
    configuration.domain_name
  end

  let(:api_gateway_domain_name) do
    api_gateway_v2_client
      .get_domain_name(domain_name:)
  rescue Aws::ApiGatewayV2::Errors::NotFound
    nil
  end

  let(:api_gateway_api_mapping) do
    api_gateway_v2_client
      .get_api_mapping(
        domain_name:,
        api_mapping_id: output_api_mapping_id
      )
  rescue Aws::ApiGatewayV2::Errors::NotFound
    nil
  end

  before(:context) do
    provision(:stage) do |vars|
      vars.merge(
        api_id: output(:prerequisites, 'api_id'),
        hosted_zone_id: configuration.public_zone_id,
        domain_name: configuration.domain_name,
        domain_name_certificate_arn:
          output(:prerequisites, 'certificate_arn')
      )
    end
  end

  after(:context) do
    destroy(:stage) do |vars|
      vars.merge(
        api_id: output(:prerequisites, 'api_id'),
        hosted_zone_id: configuration.public_zone_id,
        domain_name: configuration.domain_name,
        domain_name_certificate_arn:
          output(:prerequisites, 'certificate_arn')
      )
    end
  end

  describe 'by default' do
    before(:context) do
      provision(:stage) do |vars|
        vars.merge(
          api_id: output(:prerequisites, 'api_id'),
          hosted_zone_id: configuration.public_zone_id,
          domain_name: configuration.domain_name,
          domain_name_certificate_arn:
            output(:prerequisites, 'certificate_arn')
        )
      end
    end

    it 'creates a domain name' do
      expect(api_gateway_domain_name).not_to(be_nil)
    end

    it 'maps the domain name to the default stage' do
      expect(api_gateway_api_mapping).not_to(be_nil)
    end

    it 'uses the provided certificate ARN' do
      expect(api_gateway_domain_name
               .domain_name_configurations[0]
               .certificate_arn)
        .to(eq(domain_name_certificate_arn))
    end

    it 'uses an endpoint type of REGIONAL' do
      expect(api_gateway_domain_name
               .domain_name_configurations[0]
               .endpoint_type)
        .to(eq('REGIONAL'))
    end

    it 'uses a security policy of TLS_1_2' do
      expect(api_gateway_domain_name
               .domain_name_configurations[0]
               .security_policy)
        .to(eq('TLS_1_2'))
    end

    it 'includes the component and deployment identifier as tags' do
      expect(api_gateway_domain_name.tags)
        .to(include(
              {
                'Component' => component,
                'DeploymentIdentifier' => deployment_identifier
              }
            ))
    end
  end

  describe 'when include_domain_name is false' do
    before(:context) do
      provision(:stage) do |vars|
        vars.merge(
          api_id: output(:prerequisites, 'api_id'),
          hosted_zone_id: configuration.public_zone_id,
          include_domain_name: false
        )
      end
    end

    it 'does not create a domain name for the default stage' do
      expect(api_gateway_domain_name).to(be_nil)
    end
  end

  describe 'when include_domain_name is true' do
    before(:context) do
      provision(:stage) do |vars|
        vars.merge(
          api_id: output(:prerequisites, 'api_id'),
          hosted_zone_id: configuration.public_zone_id,
          include_domain_name: true,
          domain_name: configuration.domain_name,
          domain_name_certificate_arn:
            output(:prerequisites, 'certificate_arn')
        )
      end
    end

    it 'creates a domain name' do
      expect(api_gateway_domain_name).not_to(be_nil)
    end

    it 'maps the domain name to the default stage' do
      expect(api_gateway_api_mapping).not_to(be_nil)
    end

    it 'uses the provided certificate ARN' do
      expect(api_gateway_domain_name
               .domain_name_configurations[0]
               .certificate_arn)
        .to(eq(domain_name_certificate_arn))
    end

    it 'uses an endpoint type of REGIONAL' do
      expect(api_gateway_domain_name
               .domain_name_configurations[0]
               .endpoint_type)
        .to(eq('REGIONAL'))
    end

    it 'uses a security policy of TLS_1_2' do
      expect(api_gateway_domain_name
               .domain_name_configurations[0]
               .security_policy)
        .to(eq('TLS_1_2'))
    end

    it 'includes the component and deployment identifier as tags' do
      expect(api_gateway_domain_name.tags)
        .to(include(
              {
                'Component' => component,
                'DeploymentIdentifier' => deployment_identifier
              }
            ))
    end
  end

  describe 'when tags are provided and include_default_tags is not provided' do
    before(:context) do
      provision(:stage) do |vars|
        vars.merge(
          api_id: output(:prerequisites, 'api_id'),
          hosted_zone_id: configuration.public_zone_id,
          domain_name: configuration.domain_name,
          domain_name_certificate_arn:
            output(:prerequisites, 'certificate_arn'),
          tags: { Alpha: 'beta', Gamma: 'delta' }
        )
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(api_gateway_domain_name.tags)
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
      provision(:stage) do |vars|
        vars.merge(
          api_id: output(:prerequisites, 'api_id'),
          hosted_zone_id: configuration.public_zone_id,
          domain_name: configuration.domain_name,
          domain_name_certificate_arn:
            output(:prerequisites, 'certificate_arn'),
          include_default_tags: false,
          tags: { Alpha: 'beta', Gamma: 'delta' }
        )
      end
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'includes only the provided tags' do
      expect(api_gateway_domain_name.tags)
        .to(include(
              {
                'Alpha' => 'beta',
                'Gamma' => 'delta'
              }
            ))
      expect(api_gateway_domain_name.tags)
        .not_to(include(
                  {
                    'Component' => component,
                    'DeploymentIdentifier' => deployment_identifier
                  }
                ))
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  describe 'when tags are provided and include_default_tags is true' do
    before(:context) do
      provision(:stage) do |vars|
        vars.merge(
          api_id: output(:prerequisites, 'api_id'),
          hosted_zone_id: configuration.public_zone_id,
          domain_name: configuration.domain_name,
          domain_name_certificate_arn:
            output(:prerequisites, 'certificate_arn'),
          include_default_tags: true,
          tags: { Alpha: 'beta', Gamma: 'delta' }
        )
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(api_gateway_domain_name.tags)
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
      provision(:stage) do |vars|
        vars.merge(
          api_id: output(:prerequisites, 'api_id'),
          hosted_zone_id: configuration.public_zone_id,
          domain_name: configuration.domain_name,
          domain_name_certificate_arn:
            output(:prerequisites, 'certificate_arn'),
          include_default_tags: false
        )
      end
    end

    it 'does not include default tags' do
      expect(api_gateway_domain_name.tags)
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
      provision(:stage) do |vars|
        vars.merge(
          api_id: output(:prerequisites, 'api_id'),
          hosted_zone_id: configuration.public_zone_id,
          domain_name: configuration.domain_name,
          domain_name_certificate_arn:
            output(:prerequisites, 'certificate_arn'),
          include_default_tags: true
        )
      end
    end

    it 'includes default tags' do
      expect(api_gateway_domain_name.tags)
        .to(include(
              {
                'Component' => component,
                'DeploymentIdentifier' => deployment_identifier
              }
            ))
    end
  end
end