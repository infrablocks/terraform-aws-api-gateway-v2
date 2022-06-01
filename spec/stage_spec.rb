# frozen_string_literal: true

require 'spec_helper'

fdescribe 'stage' do
  let(:component) { vars(:stage).component }
  let(:deployment_identifier) { vars(:stage).deployment_identifier }

  let(:stage_name) { vars(:stage).name }

  let(:api_id) do
    output(:prerequisites, 'api_id')
  end

  let(:output_stage_id) do
    output(:stage, 'stage_id')
  end

  let(:api_gateway_stages) do
    api_gateway_v2_client.get_stages(api_id:).items
  end

  let(:api_gateway_stage) do
    api_gateway_stages[0]
  end

  before(:context) do
    provision(:stage) do |vars|
      vars.merge(
        api_id: output(:prerequisites, 'api_id'),
        include_domain_name: false
      )
    end
  end

  after(:context) do
    destroy(:stage) do |vars|
      vars.merge(
        api_id: output(:prerequisites, 'api_id'),
        include_domain_name: false
      )
    end
  end

  describe 'by default' do
    it 'creates a stage' do
      expect(api_gateway_stages.length).to(eq(1))
    end

    it 'uses the provided stage name' do
      expect(api_gateway_stage.stage_name).to(eq(stage_name))
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'uses a stage description including the component and ' \
       'deployment identifier' do
      expect(api_gateway_stage.description)
        .to(match(/.*#{component}.*/))
      expect(api_gateway_stage.description)
        .to(match(/.*#{deployment_identifier}.*/))
    end
    # rubocop:enable RSpec/MultipleExpectations

    it 'auto-deploys the stage' do
      expect(api_gateway_stage.auto_deploy).to(be(true))
    end

    it 'includes the component and deployment identifier as tags' do
      expect(api_gateway_stage.tags)
        .to(include(
              {
                'Component' => component,
                'DeploymentIdentifier' => deployment_identifier
              }
            ))
    end
  end

  describe 'when enable_auto_deploy is false' do
    before(:context) do
      provision(:stage) do |vars|
        vars.merge(
          api_id: output(:prerequisites, 'api_id'),
          enable_auto_deploy: false,
          include_domain_name: false
        )
      end
    end

    it 'sets auto deploy to false on the stage' do
      expect(api_gateway_stage.auto_deploy).to(be(false))
    end
  end

  describe 'when enable_auto_deploy is true' do
    before(:context) do
      provision(:stage) do |vars|
        vars.merge(
          api_id: output(:prerequisites, 'api_id'),
          enable_auto_deploy: true,
          include_domain_name: false
        )
      end
    end

    it 'sets auto deploy to true on the stage' do
      expect(api_gateway_stage.auto_deploy).to(be(true))
    end
  end

  describe 'when tags are provided and include_default_tags is not provided' do
    before(:context) do
      provision(:stage) do |vars|
        vars.merge(
          api_id: output(:prerequisites, 'api_id'),
          include_domain_name: false,
          tags: { Alpha: 'beta', Gamma: 'delta' }
        )
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(api_gateway_stage.tags)
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
          include_domain_name: false,
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
          include_domain_name: false,
          include_default_tags: true,
          tags: { Alpha: 'beta', Gamma: 'delta' }
        )
      end
    end

    it 'includes the provided tags alongside the defaults' do
      expect(api_gateway_stage.tags)
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
          include_domain_name: false,
          include_default_tags: false
        )
      end
    end

    it 'does not include default tags' do
      expect(api_gateway_stage.tags)
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
          include_domain_name: false,
          include_default_tags: true
        )
      end
    end

    it 'includes default tags' do
      expect(api_gateway_stage.tags)
        .to(include(
              {
                'Component' => component,
                'DeploymentIdentifier' => deployment_identifier
              }
            ))
    end
  end
end
