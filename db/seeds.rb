# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Cluster.create(name: "Los Angeles", subdomain: "la")
Cluster.create(name: "New York", subdomain: "nyc")
Cluster.create(name: "Frankfurt", subdomain: "fra")
Cluster.create(name: "Hong Kong", subdomain: "hongkong")
Server.create(friendly_name: "ubiq-1", cluster_id: 1, ip_string: "123.123.123.123")
Server.create(friendly_name: "ubiq-2", cluster_id: 1, ip_string: "125.125.125.125")
Server.create(friendly_name: "leaseweb-de-1", cluster_id: 3, ip_string: "12.12.12.12")
Server.create(friendly_name: "rackspace-1", cluster_id: 4, ip_string: "234.234.234.234")
Server.create(friendly_name: "rackspace-2", cluster_id: 4, ip_string: "235.235.235.235")
Server.create(friendly_name: "example-1", cluster_id: 4, ip_string: "12.12.12.12")
