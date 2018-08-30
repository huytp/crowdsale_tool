class AddEmailToKycAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :kyc_addresses, :email, :string
  end
end
