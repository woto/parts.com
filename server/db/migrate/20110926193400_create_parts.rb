class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.string :catalog_number, :null => false
      t.references :manufacturer, :null => false
      t.float :price
      t.datetime :price_checked
      t.datetime :price_updated

      t.timestamps
    end
    add_index :parts, :manufacturer_id
  end
end
