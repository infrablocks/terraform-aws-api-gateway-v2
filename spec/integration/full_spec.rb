# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
describe 'full example' do
  let(:component) do
    var(role: :full, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :full, name: 'deployment_identifier')
  end
  let(:domain_name) do
    var(role: :full, name: 'domain_name')
  end
  let(:hosted_zone_id) do
    var(role: :full, name: 'public_zone_id')
  end
  let(:subnet_ids) do
    output(role: :full, name: 'private_subnet_ids')
  end

  let(:output_api_gateway_id) do
    output(role: :full, name: 'api_gateway_id')
  end
  let(:output_api_gateway_arn) do
    output(role: :full, name: 'api_gateway_arn')
  end
  let(:output_api_gateway_name) do
    output(role: :full, name: 'api_gateway_name')
  end
  let(:output_default_stage_api_mapping_id) do
    output(role: :full, name: 'default_stage_api_mapping_id')
  end
  let(:output_default_stage_domain_name_certificate_arn) do
    output(role: :full, name: 'certificate_arn')
  end
  let(:output_domain_name_configuration) do
    output(role: :full, name: 'default_stage_domain_name_configuration')
  end
  let(:output_vpc_link_default_security_group_id) do
    output(role: :full, name: 'vpc_link_default_security_group_id')
  end

  let(:output_vpc_link_id) do
    output(role: :full, name: 'vpc_link_id')
  end

  let(:default_stage_hosted_zone_id) do
    output_domain_name_configuration[:hosted_zone_id]
  end

  let(:default_stage_target_domain_name) do
    output_domain_name_configuration[:target_domain_name]
  end

  let(:hosted_zone) do
    route53_hosted_zone(hosted_zone_id)
  end

  let(:api_gateway) do
    api_gateway_v2_client.get_api(api_id: output_api_gateway_id)
  rescue Aws::ApiGatewayV2::Errors::NotFoundException
    nil
  end

  let(:api_gateway_stages) do
    api_gateway_v2_client.get_stages(api_id: output_api_gateway_id).items
  end

  let(:api_gateway_stage) do
    api_gateway_stages[0]
  end

  let(:api_gateway_default_stage_domain_name) do
    api_gateway_v2_client
      .get_domain_name(domain_name:)
  rescue Aws::ApiGatewayV2::Errors::NotFound
    nil
  end

  let(:api_gateway_default_stage_api_mapping) do
    api_gateway_v2_client
      .get_api_mapping(
        domain_name:,
        api_mapping_id: output_default_stage_api_mapping_id
      )
  rescue Aws::ApiGatewayV2::Errors::NotFound
    nil
  end

  let(:vpc_link_default_security_group) do
    security_group(output_vpc_link_default_security_group_id)
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
    apply(role: :full)
  end

  after(:context) do
    destroy(
      role: :full,
      only_if: -> { !ENV['FORCE_DESTROY'].nil? || ENV['SEED'].nil? }
    )
  end

  describe 'API gateway' do
    it 'creates an API gateway' do
      expect(api_gateway).not_to(be_nil)
    end

    it 'includes the component in the name' do
      expect(api_gateway.name).to(match(/.*#{component}.*/))
    end

    it 'includes the deployment identifier in the name' do
      expect(api_gateway.name).to(match(/.*#{deployment_identifier}.*/))
    end

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

    it 'uses a protocol type of HTTP' do
      expect(api_gateway.protocol_type).to(eq('HTTP'))
    end

    it 'enables the execute API' do
      expect(api_gateway.disable_execute_api_endpoint).to(be(false))
    end

    it 'includes the component in the description' do
      expect(api_gateway.description)
        .to(match(/.*#{component}.*/))
    end

    it 'includes the deployment identifier in the description' do
      expect(api_gateway.description)
        .to(match(/.*#{deployment_identifier}.*/))
    end
  end

  describe 'default stage' do
    it 'creates a single stage' do
      expect(api_gateway_stages.length).to(eq(1))
    end

    it 'uses a stage name of $default' do
      expect(api_gateway_stage.stage_name).to(eq('$default'))
    end

    it 'includes the component in the stage description' do
      expect(api_gateway_stage.description)
        .to(match(/.*#{component}.*/))
    end

    it 'includes the deployment identifier in the stage description' do
      expect(api_gateway_stage.description)
        .to(match(/.*#{deployment_identifier}.*/))
    end

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

  describe 'default stage domain name' do
    it 'creates a domain name' do
      expect(api_gateway_default_stage_domain_name).not_to(be_nil)
    end

    it 'maps the domain name to the default stage' do
      expect(api_gateway_default_stage_api_mapping).not_to(be_nil)
    end

    it 'uses the provided certificate ARN' do
      expect(api_gateway_default_stage_domain_name
               .domain_name_configurations[0]
               .certificate_arn)
        .to(eq(output_default_stage_domain_name_certificate_arn))
    end

    it 'uses an endpoint type of REGIONAL' do
      expect(api_gateway_default_stage_domain_name
               .domain_name_configurations[0]
               .endpoint_type)
        .to(eq('REGIONAL'))
    end

    it 'uses a security policy of TLS_1_2' do
      expect(api_gateway_default_stage_domain_name
               .domain_name_configurations[0]
               .security_policy)
        .to(eq('TLS_1_2'))
    end

    it 'includes the component and deployment identifier as tags' do
      expect(api_gateway_default_stage_domain_name.tags)
        .to(include(
              {
                'Component' => component,
                'DeploymentIdentifier' => deployment_identifier
              }
            ))
    end
  end

  describe 'default stage route53 record' do
    it 'creates a DNS record for the default stage domain name' do
      expect(hosted_zone)
        .to(have_record_set("#{domain_name}.")
              .alias(
                "#{default_stage_target_domain_name}.",
                default_stage_hosted_zone_id
              ))
    end
  end

  describe 'VPC link security group' do
    it 'creates the default security group' do
      expect(vpc_link_default_security_group).to(exist)
    end

    it 'has a single ingress rule' do
      expect(vpc_link_default_security_group.inbound_rule_count).to(eq(1))
    end

    it 'has a single egress rule' do
      expect(vpc_link_default_security_group.outbound_rule_count).to(eq(1))
    end

    it 'allows ingress access on port 443 from all IP addresses' do
      expect(vpc_link_default_security_group.inbound)
        .to(be_opened(443)
              .protocol('tcp')
              .for('0.0.0.0/0'))
    end

    it 'allows egress access on all ports to all IPs' do
      expect(vpc_link_default_security_group)
        .to(have_outbound_rule(
              ip_protocol: 'all',
              from_port: '-1',
              to_port: '-1',
              ip_range: '0.0.0.0/0'
            ))
    end

    it 'includes the component and deployment identifier as tags' do
      expect(tag_map(vpc_link_default_security_group))
        .to(include(
              {
                'Component' => component,
                'DeploymentIdentifier' => deployment_identifier
              }
            ))
    end
  end

  describe 'by default' do
    it 'creates a VPC link in the subnets with the provided IDs' do
      expect(created_vpc_link).not_to(be_nil)
    end

    it 'includes the component in the name' do
      expect(created_vpc_link.name)
        .to(match(/.*#{component}.*/))
    end

    it 'includes the deployment identifier in the name' do
      expect(created_vpc_link.name)
        .to(match(/.*#{deployment_identifier}.*/))
    end

    it 'outputs the VPC link ID' do
      expect(created_vpc_link.vpc_link_id).to(eq(output_vpc_link_id))
    end

    it 'includes the component and deployment identifier as tags' do
      expect(created_vpc_link.tags)
        .to(include(
              {
                'Component' => component,
                'DeploymentIdentifier' => deployment_identifier
              }
            ))
    end
  end

  def tag_map(security_group)
    security_group
      .tags
      .inject({}) { |acc, tag| acc.merge(tag.key => tag.value) }
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
