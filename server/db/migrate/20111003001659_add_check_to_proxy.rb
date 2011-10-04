class AddCheckToProxy < ActiveRecord::Migration
  def change
    add_column :proxies, :check, :string
  end
end
