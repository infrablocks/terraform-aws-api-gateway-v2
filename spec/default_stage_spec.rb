# frozen_string_literal: true

require 'spec_helper'

describe 'default stage' do
  let(:output_api_gateway_id) do
    output_for(:harness, 'api_gateway_id')
  end

  let(:api_gateway_stages) do
    api_gateway_v2_client.get_stages(api_id: output_api_gateway_id)
  end

  describe 'by default' do
    it 'creates a single stage' do
      expect(api_gateway_stages.items.length).to(eq(1))
    end

    it 'uses a stage name of $default' do
      stage = api_gateway_stages.items[0]
      expect(stage.stage_name).to(eq('$default'))
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'uses a stage description including the component and ' \
       'deployment identifier' do
      require 'pp'
      stage = api_gateway_stages.items[0]
      pp stage
      expect(stage.description)
        .to(match(/.*#{vars.component}.*/))
      expect(stage.description)
        .to(match(/.*#{vars.deployment_identifier}.*/))
    end
    # rubocop:enable RSpec/MultipleExpectations

    it 'auto-deploys the stage' do
      stage = api_gateway_stages.items[0]
      expect(stage.auto_deploy).to(be(true))
    end
  end

  describe 'when include_default_stage is false' do
    before do
      reprovision do |vars|
        vars.merge(include_default_stage: false)
      end
    end

    it 'does not create a stage' do
      expect(api_gateway_stages.items.length).to(eq(0))
    end
  end

  describe 'when include_default_stage is true' do
    before do
      reprovision do |vars|
        vars.merge(include_default_stage: true)
      end
    end

    it 'creates a single stage' do
      expect(api_gateway_stages.items.length).to(eq(1))
    end

    it 'uses a stage name of $default' do
      stage = api_gateway_stages.items[0]
      expect(stage.stage_name).to(eq('$default'))
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'uses a stage description including the component and ' \
       'deployment identifier' do
      require 'pp'
      stage = api_gateway_stages.items[0]
      pp stage
      expect(stage.description)
        .to(match(/.*#{vars.component}.*/))
      expect(stage.description)
        .to(match(/.*#{vars.deployment_identifier}.*/))
    end
    # rubocop:enable RSpec/MultipleExpectations

    it 'auto-deploys the stage' do
      stage = api_gateway_stages.items[0]
      expect(stage.auto_deploy).to(be(true))
    end
  end

  describe 'when enable_auto_deploy_for_default_stage is false' do
    before do
      reprovision do |vars|
        vars.merge(enable_auto_deploy_for_default_stage: false)
      end
    end

    it 'sets auto deploy to false on the stage' do
      stage = api_gateway_stages.items[0]
      expect(stage.auto_deploy).to(be(false))
    end
  end

  describe 'when enable_auto_deploy_for_default_stage is true' do
    before do
      reprovision do |vars|
        vars.merge(enable_auto_deploy_for_default_stage: true)
      end
    end

    it 'sets auto deploy to true on the stage' do
      stage = api_gateway_stages.items[0]
      expect(stage.auto_deploy).to(be(true))
    end
  end
end
