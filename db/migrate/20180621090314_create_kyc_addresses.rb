class CreateKycAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :kyc_addresses do |t|
      t.string :address
      t.string :username
      t.string :mis_amount
      t.string :btc_amount

      t.timestamps
    end
  end
end
