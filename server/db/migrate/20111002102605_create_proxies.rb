class CreateProxies < ActiveRecord::Migration
  def change
    create_table :proxies do |t|
      t.datetime :timestamp
      t.string :ip
      t.string :port
      t.string :country
      t.integer :speed
      t.integer :connection_time
      t.string :protocol
      t.string :anonymity
      t.integer :good, :default => 0, :null => false
      t.string :source

      t.timestamps
    end
  end
end
