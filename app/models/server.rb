class Server < ApplicationRecord
  belongs_to :cluster, :foreign_key => :cluster_id

  attr_accessor :domain_string

  def get_domain_string()
    cluster = Cluster.find(self.cluster_id)

    hosted_zone_id = "/hostedzone/Z0611413OT6M3AK754LE"
    domain_name = HostedServer.get_domain_name(hosted_zone_id)

    domain_string = cluster.subdomain + "." + domain_name
    return domain_string
  end
end
