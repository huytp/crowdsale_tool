class AddReferenceToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_reference :transactions, :kyc_address, foreign_key: true
    remove_column :transactions, :address
  end
end
