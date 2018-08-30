class CreateCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.datetime :time_start
      t.datetime :time_end
      t.integer :mis_amount
      t.decimal :total_btc, :precision => 18, :scale => 8

      t.timestamps
    end
  end
end
