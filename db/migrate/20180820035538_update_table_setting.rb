class UpdateTableSetting < ActiveRecord::Migration[5.1]
  def self.up
    add_column :settings, :max_btc, :decimal, default: 10
    remove_column :settings, :time_finish
    remove_column :settings, :require_time
  end

  def self.down
    remove_column :settings, :max_btc
    add_column :settings, :time_finish, :datetime
    add_column :settings, :require_time, :boolean
  end
end
