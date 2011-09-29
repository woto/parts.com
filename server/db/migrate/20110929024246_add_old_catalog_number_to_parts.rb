class AddOldCatalogNumberToParts < ActiveRecord::Migration
  def change
    add_column :parts, :old_catalog_number, :string
  end
end
