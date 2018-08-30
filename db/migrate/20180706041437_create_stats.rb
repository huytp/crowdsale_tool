class CreateStats < ActiveRecord::Migration[5.1]
  def change
    create_table :stats do |t|
      t.integer :count, default: 1
      t.integer :last, default: 1

      t.timestamps
    end
  end
end
