class AddOverloadToFixedCampaign < ActiveRecord::Migration[5.1]
  def change
    add_column :histories, :overload, :boolean, default: false
  end
end
