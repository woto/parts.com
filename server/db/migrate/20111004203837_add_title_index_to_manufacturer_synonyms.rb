class AddTitleIndexToManufacturerSynonyms < ActiveRecord::Migration
  def change
    add_index(:manufacturer_synonyms, :title)
  end
end
