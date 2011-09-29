class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.string :price, :default => 0, :null => false

      t.timestamps
    end
  end
end
