class ServerSerializer < ActiveModel::Serializer
  attributes :id, :friendly_name, :ip_string, :domain_string
  belongs_to :cluster, :foreign_key => :cluster_id
end
