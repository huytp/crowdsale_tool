class ChangeColumnTypeOnFixedCampaigns < ActiveRecord::Migration[5.1]
  def change
    change_column :fixed_campaigns, :start_btc, :decimal, :precision => 18, :scale => 8
    change_column :fixed_campaigns, :end_btc, :decimal, :precision => 18, :scale => 8
    change_column :fixed_campaigns, :btc_to_mis, :decimal, :precision => 18, :scale => 8
  end
end
