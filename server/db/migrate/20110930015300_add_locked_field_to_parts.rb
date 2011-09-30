class AddLockedFieldToParts < ActiveRecord::Migration
  def change
    add_column :parts, :locked, :boolean, :default => 0, :null => false
  end
end
