class CreateServers < ActiveRecord::Migration[6.1]
  def change
    create_table :servers do |t|
      t.string :friendly_name
      t.string :ip_string
      t.integer :cluster_id

      t.timestamps
    end
  end
end
