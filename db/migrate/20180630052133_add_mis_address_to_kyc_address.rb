class AddMisAddressToKycAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :kyc_addresses, :mis_address, :string
  end
end
