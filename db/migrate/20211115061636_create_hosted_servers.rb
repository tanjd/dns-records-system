class CreateHostedServers < ActiveRecord::Migration[6.1]
  def change
    create_table :hosted_servers,
                 { :id => false,
                   :primary_key => :ip_string } do |t|
      t.string :ip_string
      t.string :domain_string

      t.timestamps
    end
  end
end
