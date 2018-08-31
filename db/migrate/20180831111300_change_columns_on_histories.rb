class ChangeColumnsOnHistories < ActiveRecord::Migration[5.1]
  def change
    change_column :histories, :value, :decimal, :precision => 18, :scale => 8
    change_column :settings, :max_btc, :decimal, :precision => 18, :scale => 8
  end
end
