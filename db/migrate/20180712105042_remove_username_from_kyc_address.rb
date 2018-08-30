class RemoveUsernameFromKycAddress < ActiveRecord::Migration[5.1]
  def change
    remove_column :kyc_addresses, :username
  end
end
