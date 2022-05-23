# frozen_string_literal: true

require 'spec_helper'

describe 'default stage' do
  let(:output_api_gateway_id) do
    output_for(:harness, 'api_gateway_id')
  end

  let(:api_gateway_stages) do
    api_gateway_v2_client.get_stages(api_id: output_api_gateway_id).items
  end

  let(:api_gateway_stage) do
    api_gateway_stages[0]
  end

  before(:context) do
    provision { |vars| vars.merge(include_default_stage_domain_name: false) }
  end

  after(:context) do
    destroy { |vars| vars.merge(include_default_stage_domain_name: false) }
  end

  describe 'by default' do
    it 'creates a single stage' do
      expect(api_gateway_stages.length).to(eq(1))
    end

    it 'uses a stage name of $default' do
      expect(api_gateway_stage.stage_name).to(eq('$default'))
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'uses a stage description including the component and ' \
       'deployment identifier' do
      expect(api_gateway_stage.description)
        .to(match(/.*#{vars.component}.*/))
      expect(api_gateway_stage.description)
        .to(match(/.*#{vars.deployment_identifier}.*/))
    end
    # rubocop:enable RSpec/MultipleExpectations

    it 'auto-deploys the stage' do
      expect(api_gateway_stage.auto_deploy).to(be(true))
    end

    it 'includes the component and deployment identifier as tags' do
      expect(api_gateway_stage.tags)
        .to(include(
              {
                'Component' => vars.component,
                'DeploymentIdentifier' => vars.deployment_identifier
              }
            ))
    end
  end

  describe 'when include_default_stage is false' do
    before(:context) do
      provision do |vars|
        vars.merge(
          include_default_stage: false
        )
      end
    end

    it 'does not create a stage' do
      expect(api_gateway_stages.length).to(eq(0))
    end
  end

  describe 'when include_default_stage is true' do
    before(:context) do
      provision do |vars|
        vars.merge(
          include_default_stage: true,
          include_default_stage_domain_name: false
        )
      end
    end

    it 'creates a single stage' do
      expect(api_gateway_stages.length).to(eq(1))
    end

    it 'uses a stage name of $default' do
      expect(api_gateway_stage.stage_name).to(eq('$default'))
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'uses a stage description including the component and ' \
       'deployment identifier' do
      expect(api_gateway_stage.description)
        .to(match(/.*#{vars.component}.*/))
      expect(api_gateway_stage.description)
        .to(match(/.*#{vars.deployment_identifier}.*/))
    end
    # rubocop:enable RSpec/MultipleExpectations

    it 'auto-deploys the stage' do
      expect(api_gateway_stage.auto_deploy).to(be(true))
    end

    it 'includes the component and deployment identifier as tags' do
      expect(api_gateway_stage.tags)
        .to(include(
              {
                'Component' => vars.component,
                'DeploymentIdentifier' => vars.deployment_identifier
              }
            ))
    end
  end

  describe 'when enable_default_stage_auto_deploy is false' do
    before(:context) do
      provision do |vars|
        vars.merge(
          enable_default_stage_auto_deploy: false,
          include_default_stage_domain_name: false
        )
      end
    end

    it 'sets auto deploy to false on the stage' do
      expect(api_gateway_stage.auto_deploy).to(be(false))
    end
  end

  describe 'when enable_default_stage_auto_deploy is true' do
    before(:context) do
      provision do |vars|
        vars.merge(
          enable_default_stage_auto_deploy: true,
          include_default_stage_domain_name: false
        )
      end
    end

    it 'sets auto deploy to true on the stage' do
      expect(api_gateway_stage.auto_deploy).to(be(true))
    end
  end

  describe 'when tags are provided and include_default_tags is not provided' do
    before(:context) do
      provision do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          tags: { Alpha: 'beta', Gamma: 'delta' }
        )
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(api_gateway_stage.tags)
        .to(include(
              {
                'Component' => vars.component,
                'DeploymentIdentifier' => vars.deployment_identifier,
                'Alpha' => 'beta',
                'Gamma' => 'delta'
              }))
    end
  end

  describe 'when tags are provided and include_default_tags is false' do
    before(:context) do
      provision do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          include_default_tags: false,
          tags: { Alpha: 'beta', Gamma: 'delta' }
        )
      end
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'includes only the provided tags' do
      expect(api_gateway_stage.tags)
        .to(include(
              {
                'Alpha' => 'beta',
                'Gamma' => 'delta'
              }
            ))
      expect(api_gateway_stage.tags)
        .not_to(include(
                  {
                    'Component' => vars.component,
                    'DeploymentIdentifier' => vars.deployment_identifier
                  }
                ))
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  describe 'when tags are provided and include_default_tags is true' do
    before(:context) do
      provision do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          include_default_tags: true,
          tags: { Alpha: 'beta', Gamma: 'delta' }
        )
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(api_gateway_stage.tags)
        .to(include(
              {
                'Component' => vars.component,
                'DeploymentIdentifier' => vars.deployment_identifier,
                'Alpha' => 'beta',
                'Gamma' => 'delta'
              }
            ))
    end
  end

  describe 'when include_default_tags is false' do
    before(:context) do
      provision do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          include_default_tags: false
        )
      end
    end

    it 'does not include default tags' do
      expect(api_gateway_stage.tags)
        .not_to(include(
                  {
                    'Component' => vars.component,
                    'DeploymentIdentifier' => vars.deployment_identifier
                  }
                ))
    end
  end

  describe 'when include_default_tags is true' do
    before(:context) do
      provision do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          include_default_tags: true
        )
      end
    end

    it 'includes default tags' do
      expect(api_gateway_stage.tags)
        .to(include(
              {
                'Component' => vars.component,
                'DeploymentIdentifier' => vars.deployment_identifier
              }
            ))
    end
  end
end
