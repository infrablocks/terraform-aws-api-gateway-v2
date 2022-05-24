# frozen_string_literal: true

require 'spec_helper'

describe 'default stage route53 record' do
  let(:hosted_zone_id) { vars.hosted_zone_id }

  let(:hosted_zone) do
    route53_hosted_zone(hosted_zone_id)
  end

  let(:default_stage_domain_name) do
    configuration.domain_name
  end

  let(:output_domain_name_configuration) do
    output_for(
      :harness,
      'default_stage_domain_name_configuration'
    )
  end

  let(:default_stage_hosted_zone_id) do
    output_domain_name_configuration[:hosted_zone_id]
  end

  let(:default_stage_target_domain_name) do
    output_domain_name_configuration[:target_domain_name]
  end

  before(:context) do
    provision do |vars|
      vars.merge(
        default_stage_domain_name: configuration.domain_name,
        default_stage_domain_name_certificate_arn:
          output_for(:prerequisites, 'certificate_arn')
      )
    end
  end

  after(:context) do
    destroy do |vars|
      vars.merge(
        default_stage_domain_name: configuration.domain_name,
        default_stage_domain_name_certificate_arn:
          output_for(:prerequisites, 'certificate_arn')
      )
    end
  end

  describe 'by default' do
    it 'creates a DNS record for the default stage domain name' do
      expect(hosted_zone)
        .to(have_record_set("#{default_stage_domain_name}.")
              .alias(
                "#{default_stage_target_domain_name}.",
                default_stage_hosted_zone_id
              ))
    end
  end

  describe 'when include_default_stage_domain_name is false and ' \
           'include_default_stage_dns_record is not provided' do
    before(:context) do
      provision do |vars|
        vars.merge(
          include_default_stage_domain_name: false
        )
      end
    end

    it 'does not create a DNS record for the default stage domain name' do
      matching_resource_record_sets =
        alias_resource_record_sets(
          hosted_zone_id,
          default_stage_domain_name
        )

      expect(matching_resource_record_sets.length).to(eq(0))
    end
  end

  describe 'when include_default_stage_domain_name is true and ' \
           'include_default_stage_dns_record is not provided' do
    before(:context) do
      provision do |vars|
        vars.merge(
          include_default_stage_domain_name: true,
          default_stage_domain_name: configuration.domain_name,
          default_stage_domain_name_certificate_arn:
            output_for(:prerequisites, 'certificate_arn')
        )
      end
    end

    it 'creates a DNS record for the default stage domain name' do
      expect(hosted_zone)
        .to(have_record_set("#{default_stage_domain_name}.")
              .alias(
                "#{default_stage_target_domain_name}.",
                default_stage_hosted_zone_id
              ))
    end
  end

  describe 'when include_default_stage_domain_name is false and ' \
           'include_default_stage_dns_record is false' do
    before(:context) do
      provision do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          include_default_stage_dns_record: false
        )
      end
    end

    it 'does not create a DNS record for the default stage domain name' do
      matching_resource_record_sets =
        alias_resource_record_sets(
          hosted_zone_id,
          default_stage_domain_name
        )

      expect(matching_resource_record_sets.length).to(eq(0))
    end
  end

  describe 'when include_default_stage_domain_name is true and ' \
           'include_default_stage_dns_record is false' do
    before(:context) do
      provision do |vars|
        vars.merge(
          include_default_stage_domain_name: true,
          include_default_stage_dns_record: false,
          default_stage_domain_name: configuration.domain_name,
          default_stage_domain_name_certificate_arn:
            output_for(:prerequisites, 'certificate_arn')
        )
      end
    end

    it 'does not create a DNS record for the default stage domain name' do
      matching_resource_record_sets =
        alias_resource_record_sets(
          hosted_zone_id,
          default_stage_domain_name
        )

      expect(matching_resource_record_sets.length).to(eq(0))
    end
  end

  describe 'when include_default_stage_domain_name is false and ' \
           'include_default_stage_dns_record is true' do
    before(:context) do
      provision do |vars|
        vars.merge(
          include_default_stage_domain_name: false,
          include_default_stage_dns_record: true
        )
      end
    end

    it 'does not create a DNS record for the default stage domain name' do
      matching_resource_record_sets =
        alias_resource_record_sets(
          hosted_zone_id,
          default_stage_domain_name
        )

      expect(matching_resource_record_sets.length).to(eq(0))
    end
  end

  describe 'when include_default_stage_domain_name is true and ' \
           'include_default_stage_dns_record is true' do
    before(:context) do
      provision do |vars|
        vars.merge(
          include_default_stage_domain_name: true,
          include_default_stage_dns_record: true,
          default_stage_domain_name: configuration.domain_name,
          default_stage_domain_name_certificate_arn:
            output_for(:prerequisites, 'certificate_arn')
        )
      end
    end

    it 'creates a DNS record for the default stage domain name' do
      expect(hosted_zone)
        .to(have_record_set("#{default_stage_domain_name}.")
              .alias(
                "#{default_stage_target_domain_name}.",
                default_stage_hosted_zone_id
              ))
    end
  end

  describe 'when include_default_stage_domain_name is not provided and ' \
           'include_default_stage_dns_record is false' do
    before(:context) do
      provision do |vars|
        vars.merge(
          include_default_stage_dns_record: false,
          default_stage_domain_name: configuration.domain_name,
          default_stage_domain_name_certificate_arn:
            output_for(:prerequisites, 'certificate_arn')
        )
      end
    end

    it 'does not create a DNS record for the default stage domain name' do
      matching_resource_record_sets =
        alias_resource_record_sets(
          hosted_zone_id,
          default_stage_domain_name
        )

      expect(matching_resource_record_sets.length).to(eq(0))
    end
  end

  describe 'when include_default_stage_domain_name is not provided and ' \
           'include_default_stage_dns_record is true' do
    before(:context) do
      provision do |vars|
        vars.merge(
          include_default_stage_dns_record: true,
          default_stage_domain_name: configuration.domain_name,
          default_stage_domain_name_certificate_arn:
            output_for(:prerequisites, 'certificate_arn')
        )
      end
    end

    it 'creates a DNS record for the default stage domain name' do
      expect(hosted_zone)
        .to(have_record_set("#{default_stage_domain_name}.")
              .alias(
                "#{default_stage_target_domain_name}.",
                default_stage_hosted_zone_id
              ))
    end
  end

  def alias_resource_record_sets(zone_id, domain_name)
    route53_client
      .list_resource_record_sets(hosted_zone_id: zone_id)
      .resource_record_sets
      .reject { |record_set| record_set.alias_target.nil? }
      .select do |record_set|
      record_set.name == "#{domain_name}."
    end
  end
end
