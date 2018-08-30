class History < ApplicationRecord
  belongs_to :fixed_campaign,  optional: true
  belongs_to :kyc_address
end
