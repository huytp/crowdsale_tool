class AddMisBoughtToCampaign < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :mis_sell, :integer
  end
end
