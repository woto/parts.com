class AddNewCatalogNumberToParts < ActiveRecord::Migration
  def change
    add_column :parts, :new_catalog_number, :string
  end
end
