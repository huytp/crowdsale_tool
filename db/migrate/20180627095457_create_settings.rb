class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.integer :min_confirmation
      t.datetime :time_finish
      t.boolean :require_confirmation, default: true
      t.boolean :require_time, default: true
      t.decimal :current_rate, :precision => 18, :scale => 8

      t.timestamps
    end
  end
end
