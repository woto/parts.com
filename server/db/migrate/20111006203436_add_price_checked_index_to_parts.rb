class AddPriceCheckedIndexToParts < ActiveRecord::Migration
  def change
    add_index(:parts, :price_checked)
  end
end
