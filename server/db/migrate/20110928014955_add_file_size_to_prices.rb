class AddFileSizeToPrices < ActiveRecord::Migration
  def change
    add_column :prices, :file_size, :integer
  end
end
