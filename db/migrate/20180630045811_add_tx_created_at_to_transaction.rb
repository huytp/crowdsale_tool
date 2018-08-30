class AddTxCreatedAtToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :tx_created_at, :datetime
  end
end
