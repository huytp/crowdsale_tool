class CreateFixedCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :fixed_campaigns do |t|
      t.string :name
      t.decimal :start_btc
      t.decimal :end_btc
      t.decimal :btc_to_mis
      t.decimal :current_btc, :precision => 18, :scale => 8, default: 0

      t.timestamps
    end
  end
end
