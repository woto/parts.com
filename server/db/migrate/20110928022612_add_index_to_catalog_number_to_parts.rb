class AddIndexToCatalogNumberToParts < ActiveRecord::Migration
  def change
    add_index(:parts, :catalog_number)
  end
end
