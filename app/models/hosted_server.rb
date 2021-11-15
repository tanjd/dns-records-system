require "aws-sdk-route53"

class HostedServer < ApplicationRecord
  self.primary_key = "ip_string"

  Aws.config[:credentials] = Aws::Credentials.new(
    Rails.application.credentials.aws[:access_key_id],
    Rails.application.credentials.aws[:secret_access_key]
  )

  @client = Aws::Route53::Client.new()

  @hosted_zone_id = "/hostedzone/Z0611413OT6M3AK754LE"

  def self.get_domain_name(hosted_zone_id)
    resp = @client.get_hosted_zone({
      id: hosted_zone_id,
    })

    @domain_name = resp.hosted_zone.name
    return @domain_name
  end

  def self.get_hosted_servers_from_aws()
    hosted_servers = {}

    resp = @client.list_resource_record_sets({
      hosted_zone_id: @hosted_zone_id,
    })

    resp.resource_record_sets.each do |record|
      if record.type == "A"
        record.resource_records.each do |resource_record|
          hosted_servers[[resource_record.value, record.name]] = {}
        end
      end
    end
    return hosted_servers
  end

  def self.add_to_rotation(server)
    resource_records = [
      {
        value: server.ip_string,
      },
    ]

    cluster = Cluster.find(server.cluster_id)
    domain_string = cluster.subdomain + "." + @domain_name

    resp = @client.list_resource_record_sets({
      hosted_zone_id: @hosted_zone_id,
    })

    resp.resource_record_sets.each do |record|
      if record.type == "A" && record.name == domain_string
        record.resource_records.each do |resource_record|
          resource_records.append(
            {
              value: resource_record.value,
            }
          )
        end
        break
      end
    end

    return change_resource_record_sets("UPSERT", domain_string, resource_records)
  end

  def self.remove_from_rotation(server)
    resource_records = []
    action = ""

    cluster = Cluster.find(server.cluster_id)
    domain_string = cluster.subdomain + "." + @domain_name

    resp = @client.list_resource_record_sets({
      hosted_zone_id: @hosted_zone_id,
    })

    resp.resource_record_sets.each do |record|
      if record.type == "A" && record.name == domain_string && record.resource_records.length == 1
        action = "DELETE"
        resource_records.append(
          {
            value: server.ip_string,
          }
        )
        break
      elsif record.type == "A" && record.name == domain_string && record.resource_records.length > 1
        action = "UPSERT"
        record.resource_records.delete_if { |h| h["value"] == server.ip_string }
        resource_records = record.resource_records
        break
      end
    end

    if action != ""
      return change_resource_record_sets(action, domain_string, resource_records)
    end
    return false
  end

  def self.change_resource_record_sets(action, domain_string, resource_records)
    resp = @client.change_resource_record_sets({
      change_batch: {
        changes: [
          {
            action: action,
            resource_record_set: {
              name: domain_string,
              resource_records: resource_records,
              ttl: 300,
              type: "A",
            },
          },
        ],
      },
      hosted_zone_id: @hosted_zone_id,
    })
    return true
  rescue StandardError => e
    puts "error changing record sets: #{e.message}"
    return false
  end
end
