class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :address
      t.decimal :value, :precision => 18, :scale => 8
      t.integer :confirmation
      t.string :txid

      t.timestamps
    end
  end
end
