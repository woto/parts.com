class CreateManufacturerSynonyms < ActiveRecord::Migration
  def change
    create_table :manufacturer_synonyms do |t|
      t.string :title, :null => false
      t.belongs_to :manufacturer, :null => false

      t.timestamps
    end
  end
end
