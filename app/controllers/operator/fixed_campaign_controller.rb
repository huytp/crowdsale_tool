class Operator::FixedCampaignController < ApplicationController
  before_action :set_campaigns, only: [:index, :campaign]
  def index
    @histories = History.where(overload: true).page(params[:page])
    @total_btc = History.where(overload: true).sum(:value)
  end

  def campaign
    @campaign = FixedCampaign.find(params[:id])
    @histories = @campaign.histories.where(overload: false).group(:kyc_address_id).select("id, kyc_address_id, GROUP_CONCAT(transaction_id) AS transaction_ids, sum(value) as total").page(params[:page])
  end

  private
  def set_campaigns
    @campaigns = FixedCampaign.all
  end
end
