class CreateHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :histories do |t|
      t.belongs_to :kyc_address
      t.belongs_to :fixed_campaign
      t.belongs_to :transaction
      t.decimal :value

      t.timestamps
    end
  end
end
