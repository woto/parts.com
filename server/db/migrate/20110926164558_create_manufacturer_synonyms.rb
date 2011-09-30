class CreateManufacturerSynonyms < ActiveRecord::Migration
  def change
    create_table :manufacturer_synonyms do |t|
      t.string :title, :null => false
      t.belongs_to :manufacturer

      t.timestamps
    end
  end
end
