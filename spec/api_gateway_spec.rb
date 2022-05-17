# frozen_string_literal: true

require 'spec_helper'

describe 'API gateway' do
  # let(:requested_users) { vars.users }
  let(:output_api_gateway_id) do
    output_for(:harness, 'api_gateway_id')
  end
  let(:output_api_gateway_arn) do
    output_for(:harness, 'api_gateway_arn')
  end
  let(:output_api_gateway_name) do
    output_for(:harness, 'api_gateway_name')
  end

  let(:api_gateway) do
    api_gateway_v2_client.get_api(api_id: output_api_gateway_id)
  rescue Aws::ApiGatewayV2::Errors::NotFoundException
    nil
  end

  it 'creates an API gateway' do
    expect(api_gateway).not_to(be_nil)
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'uses a name including the component and deployment identifier' do
    expect(api_gateway.name).to(match(/.*#{vars.component}.*/))
    expect(api_gateway.name).to(match(/.*#{vars.deployment_identifier}.*/))
  end
  # rubocop:enable RSpec/MultipleExpectations

  it 'outputs the API gateway ID' do
    expect(api_gateway.api_id).to(eq(output_api_gateway_id))
  end

  it 'outputs the API gateway name' do
    expect(api_gateway.name).to(eq(output_api_gateway_name))
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'includes the component and deployment identifier as tags' do
    expect(api_gateway.tags)
      .to(include({ 'Component' => vars.component }))
    expect(api_gateway.tags)
      .to(include({ 'DeploymentIdentifier' => vars.deployment_identifier }))
  end
  # rubocop:enable RSpec/MultipleExpectations

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
        .to(match(/.*#{vars.component}.*/))
      expect(api_gateway.description)
        .to(match(/.*#{vars.deployment_identifier}.*/))
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  describe 'when protocol type is WEBSOCKET' do
    before do
      reprovision do |vars|
        vars.merge(protocol_type: 'WEBSOCKET')
      end
    end

    it 'uses a protocol type of WEBSOCKET' do
      expect(api_gateway.protocol_type).to(eq('WEBSOCKET'))
    end
  end

  describe 'when protocol type is HTTP' do
    before do
      reprovision do |vars|
        vars.merge(protocol_type: 'HTTP')
      end
    end

    it 'uses a protocol type of HTTP' do
      expect(api_gateway.protocol_type).to(eq('HTTP'))
    end
  end

  describe 'when enable_execute_api_endpoint is false' do
    before do
      reprovision do |vars|
        vars.merge(enable_execute_api_endpoint: false)
      end
    end

    it 'disables the execute API' do
      expect(api_gateway.disable_execute_api_endpoint).to(be(true))
    end
  end

  describe 'when enable_execute_api_endpoint is true' do
    before do
      reprovision do |vars|
        vars.merge(enable_execute_api_endpoint: true)
      end
    end

    it 'disables the execute API' do
      expect(api_gateway.disable_execute_api_endpoint).to(be(false))
    end
  end
end
