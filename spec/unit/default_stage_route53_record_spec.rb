# frozen_string_literal: true

require 'spec_helper'

describe 'default stage route53 record' do
  let(:hosted_zone_id) do
    output(role: :prerequisites, name: 'public_zone_id')
  end
  let(:default_stage_domain_name) do
    output(role: :prerequisites, name: 'domain_name')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'creates a DNS record for the default stage domain name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .once)
    end

    it 'uses the provided hosted zone ID' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, hosted_zone_id))
    end

    it 'uses the provided domain name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:name, default_stage_domain_name))
    end

    it 'uses a record type of A' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:type, 'A'))
    end
  end

  describe 'when include_default_stage_domain_name is false and ' \
           'include_default_stage_dns_record is not provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_default_stage_domain_name = false
      end
    end

    it 'does not create a DNS record for the default stage domain name' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_route53_record')
                  .once)
    end
  end

  describe 'when include_default_stage_domain_name is true and ' \
           'include_default_stage_dns_record is not provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_default_stage_domain_name = true
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'creates a DNS record for the default stage domain name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .once)
    end

    it 'uses the provided hosted zone ID' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, hosted_zone_id))
    end

    it 'uses the provided domain name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:name, default_stage_domain_name))
    end

    it 'uses a record type of A' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:type, 'A'))
    end
  end

  describe 'when include_default_stage_domain_name is false and ' \
           'include_default_stage_dns_record is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_default_stage_domain_name = false
        vars.include_default_stage_dns_record = false
      end
    end

    it 'does not create a DNS record for the default stage domain name' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_route53_record')
                  .once)
    end
  end

  describe 'when include_default_stage_domain_name is true and ' \
           'include_default_stage_dns_record is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_default_stage_domain_name = true
        vars.include_default_stage_dns_record = false
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'does not create a DNS record for the default stage domain name' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_route53_record')
                  .once)
    end
  end

  describe 'when include_default_stage_domain_name is false and ' \
           'include_default_stage_dns_record is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_default_stage_domain_name = false
        vars.include_default_stage_dns_record = true
      end
    end

    it 'does not create a DNS record for the default stage domain name' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_route53_record')
                  .once)
    end
  end

  describe 'when include_default_stage_domain_name is true and ' \
           'include_default_stage_dns_record is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_default_stage_domain_name = true
        vars.include_default_stage_dns_record = true
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'creates a DNS record for the default stage domain name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .once)
    end

    it 'uses the provided hosted zone ID' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, hosted_zone_id))
    end

    it 'uses the provided domain name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:name, default_stage_domain_name))
    end

    it 'uses a record type of A' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:type, 'A'))
    end
  end

  describe 'when include_default_stage_domain_name is not provided and ' \
           'include_default_stage_dns_record is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_default_stage_dns_record = false
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'does not create a DNS record for the default stage domain name' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_route53_record')
                  .once)
    end
  end

  describe 'when include_default_stage_domain_name is not provided and ' \
           'include_default_stage_dns_record is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_default_stage_dns_record = true
        vars.hosted_zone_id =
          output(role: :prerequisites, name: 'public_zone_id')
        vars.default_stage_domain_name =
          output(role: :prerequisites, name: 'domain_name')
        vars.default_stage_domain_name_certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'creates a DNS record for the default stage domain name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .once)
    end

    it 'uses the provided hosted zone ID' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, hosted_zone_id))
    end

    it 'uses the provided domain name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:name, default_stage_domain_name))
    end

    it 'uses a record type of A' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:type, 'A'))
    end
  end
end
