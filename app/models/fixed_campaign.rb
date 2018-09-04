class FixedCampaign < ApplicationRecord
  has_many :histories, dependent: :restrict_with_error
end
