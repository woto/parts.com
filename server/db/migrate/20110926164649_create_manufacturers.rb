class CreateManufacturers < ActiveRecord::Migration
  def change
    create_table :manufacturers do |t|
      t.integer :parts_com_id, :null => false
      t.string :title, :null => false

      t.timestamps
    end
  end
end
