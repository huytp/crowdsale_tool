class Operator::FixedCampaignController < ApplicationController
  before_action :set_campaigns, only: [:index, :campaign]
  before_action :find_campaign, only: [:export_campaign, :campaign]
  def index
    @histories = History.where(overload: true).page(params[:page])
    @total_btc = History.where(overload: true).sum(:value)
  end

  def campaign
    @histories = @histories.page(params[:page])
  end

  def export_campaign
    data_json = []
    ActiveRecord::Base.transaction do
      @histories.each do |history| 
        mis_amount = (history.total * @campaign.btc_to_mis).to_i
        data_json.push({mis_address: history.kyc_address.mis_address, amount: mis_amount})
      end
    end

    respond_to do |format|
      format.json { send_data data_json.to_json, type: :json, disposition: "attachment", filename: "#{@campaign.name} - #{@campaign.start_btc} to #{@campaign.end_btc}.json" }
    end
  end

  def export_overload_campaign
    @histories = History.where(overload: true)
    data_json = []
    ActiveRecord::Base.transaction do
      @histories.each do |history| 
        data_json.push({email: history.kyc_address.email, btc_address: history.kyc_address.address, amount: history.total})
      end
    end

    respond_to do |format|
      format.json { send_data data_json.to_json, type: :json, disposition: "attachment", filename: "overload-campaign-#{Time.now}.json" }
    end
  end

  private
  def find_campaign
    @campaign = FixedCampaign.find(params[:id])
    @histories = @campaign.histories.where(overload: false).group(:kyc_address_id).select("id, kyc_address_id, GROUP_CONCAT(transaction_id) AS transaction_ids, sum(value) as total")
  end
  def set_campaigns
    @campaigns = FixedCampaign.all
  end
end
