class AddTitleIndexToManufacturers < ActiveRecord::Migration
  def change
    add_index(:manufacturers, :title)
  end
end
