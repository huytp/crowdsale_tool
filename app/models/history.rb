class History < ApplicationRecord
  belongs_to :fixed_campaign,  optional: true
  belongs_to :kyc_address
  belongs_to :tran, foreign_key: :transaction_id, class_name: "Transaction"
end
