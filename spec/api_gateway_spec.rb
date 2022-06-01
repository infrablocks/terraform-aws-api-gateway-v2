# frozen_string_literal: true

require 'spec_helper'

describe 'API gateway' do
  let(:component) { vars(:root).component }
  let(:deployment_identifier) { vars(:root).deployment_identifier }

  let(:output_api_gateway_id) do
    output(:root, 'api_gateway_id')
  end
  let(:output_api_gateway_arn) do
    output(:root, 'api_gateway_arn')
  end
  let(:output_api_gateway_name) do
    output(:root, 'api_gateway_name')
  end

  let(:api_gateway) do
    api_gateway_v2_client.get_api(api_id: output_api_gateway_id)
  rescue Aws::ApiGatewayV2::Errors::NotFoundException
    nil
  end

  before(:context) do
    provision(:root) do |vars|
      vars.merge(include_default_stage_domain_name: false)
    end
  end

  after(:context) do
    destroy(:root) do |vars|
      vars.merge(include_default_stage_domain_name: false)
    end
  end

  it 'creates an API gateway' do
    expect(api_gateway).not_to(be_nil)
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'uses a name including the component and deployment identifier' do
    expect(api_gateway.name).to(match(/.*#{component}.*/))
    expect(api_gateway.name).to(match(/.*#{deployment_identifier}.*/))
  end
  # rubocop:enable RSpec/MultipleExpectations

  it 'outputs the API gateway ID' do
    expect(api_gateway.api_id).to(eq(output_api_gateway_id))
  end

  it 'outputs the API gateway name' do
    expect(api_gateway.name).to(eq(output_api_gateway_name))
  end

  it 'includes the component and deployment identifier as tags' do
    expect(api_gateway.tags)
      .to(include(
            {
              'Component' => component,
              'DeploymentIdentifier' => deployment_identifier
            }
          ))
  end

  describe 'by default' do
    it 'uses a protocol type of HTTP' do
      expect(api_gateway.protocol_type).to(eq('HTTP'))
    end

    it 'enables the execute API' do
      expect(api_gateway.disable_execute_api_endpoint).to(be(false))
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'uses a description including the component and deployment identifier' do
      expect(api_gateway.description)
        .to(match(/.*#{component}.*/))
      expect(api_gateway.description)
        .to(match(/.*#{deployment_identifier}.*/))
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  describe 'when protocol type is WEBSOCKET' do
    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          protocol_type: 'WEBSOCKET'
        )
      end
    end

    it 'uses a protocol type of WEBSOCKET' do
      expect(api_gateway.protocol_type).to(eq('WEBSOCKET'))
    end
  end

  describe 'when protocol type is HTTP' do
    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          protocol_type: 'HTTP'
        )
      end
    end

    it 'uses a protocol type of HTTP' do
      expect(api_gateway.protocol_type).to(eq('HTTP'))
    end
  end

  describe 'when enable_execute_api_endpoint is false' do
    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          enable_execute_api_endpoint: false
        )
      end
    end

    it 'disables the execute API' do
      expect(api_gateway.disable_execute_api_endpoint).to(be(true))
    end
  end

  describe 'when enable_execute_api_endpoint is true' do
    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          enable_execute_api_endpoint: true
        )
      end
    end

    it 'disables the execute API' do
      expect(api_gateway.disable_execute_api_endpoint).to(be(false))
    end
  end

  describe 'when tags are provided and include_default_tags is not provided' do
    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          tags: { Alpha: 'beta', Gamma: 'delta' }
        )
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(api_gateway.tags)
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
      provision(:root) do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          include_default_tags: false,
          tags: { Alpha: 'beta', Gamma: 'delta' }
        )
      end
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'includes only the provided tags' do
      expect(api_gateway.tags)
        .to(include(
              {
                'Alpha' => 'beta',
                'Gamma' => 'delta'
              }
            ))
      expect(api_gateway.tags)
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
      provision(:root) do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          include_default_tags: true,
          tags: { Alpha: 'beta', Gamma: 'delta' }
        )
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(api_gateway.tags)
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
      provision(:root) do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          include_default_tags: false
        )
      end
    end

    it 'does not include default tags' do
      expect(api_gateway.tags)
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
      provision(:root) do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          include_default_tags: true
        )
      end
    end

    it 'includes default tags' do
      expect(api_gateway.tags)
        .to(include(
              {
                'Component' => component,
                'DeploymentIdentifier' => deployment_identifier
              }
            ))
    end
  end
end
