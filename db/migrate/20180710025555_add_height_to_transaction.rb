class AddHeightToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :height, :integer
    remove_column :transactions, :confirmation
  end
end
