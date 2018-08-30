class Operator::HomeController < ApplicationController
  before_action :set_campaigns, only: [:index, :campaign]
  def index
    @setting = Setting.last
    kycs = KycAddress.all.order(btc_amount: :desc)
    @transactions = transaction_service.cal_balance(@setting, Transaction.all)
    @total_balance = kycs.sum(:btc_amount).to_f
    @total_balance_mis = kycs.sum(:mis_amount)
    @kycs_page = kycs.page(params[:page])
    bitcoin_usd = @setting.current_rate
    @total_balance_usd = @total_balance * bitcoin_usd 
    @stat = Stat.last
  end

  def campaign
    transaction_service
    @setting = Setting.last
    @campaign = Campaign.find_by_id(params[:id])
    kyc_ids = Hash[transaction_service.cal_balance_campaign(@setting, KycAddress.all.joins(:transactions).group(:kyc_address_id), @campaign).sum(:value).sort_by{|k, v| v}.reverse].keys
    kycs = kyc_ids.none? ? KycAddress.where(id: kyc_ids) : KycAddress.where(id: kyc_ids).order_by_ids(kyc_ids)
    @total_balance = @campaign.total_btc || 0
    bitcoin_usd = @setting.current_rate
    @total_balance_usd = @total_balance * bitcoin_usd
    @total_balance_mis = @campaign.mis_sell
    @kycs_page = kycs.page(params[:page])
    @stat = Stat.last
  end

  def import
    file = File.read(params[:kyc_list].path)
    data_hash = JSON.parse(file)
    ActiveRecord::Base.transaction do
      data_hash.each do |kyc|
        unless KycAddress.exists?(address: kyc["btc_address"])
          KycAddress.create(email: kyc["email"], address: kyc["btc_address"], mis_address: kyc["mis_address"])
        end
      end
    end
    redirect_to operator_home_index_path
  end

  def export
    @kycs = KycAddress.where.not(btc_amount: [nil, 0]).map {|kyc| {mis_address: kyc.mis_address, amount: kyc.mis_amount}}
    respond_to do |format|
      format.json { send_data @kycs.to_json(except: :id), type: :json, disposition: "attachment" }
    end
  end

  def export_campaign
    setting = Setting.last
    campaign = Campaign.find_by_id(params[:id])
    transactions = transaction_service.cal_balance_campaign(setting, Transaction.all, campaign) 
    total_balance = transactions.sum(:value)
    datum = transactions.group(:kyc_address_id).sum(:value)
    kycs = KycAddress.where(id: datum.keys)
    data_json = []
    ActiveRecord::Base.transaction do
      kycs.each do |kyc| 
        mis_amount = (((datum[kyc.id] || 0)/total_balance) * campaign.mis_amount).to_i
        data_json.push({mis_address: kyc.mis_address, amount: mis_amount})
      end
    end

    respond_to do |format|
      format.json { send_data data_json.to_json, type: :json, disposition: "attachment", filename: "#{campaign.name} - #{campaign.time_start} to #{campaign.time_end}.json" }
    end
  end

  def reload_campaign
    setting = Setting.last
    campaign = Campaign.find_by_id(params[:id])
    transactions = transaction_service.cal_balance_campaign(setting, Transaction.all, campaign) 
    total_balance = transactions.sum(:value)
    datum = transactions.group(:kyc_address_id).sum(:value)
    kycs = KycAddress.where(id: datum.keys)
    mis_sell = 0
    ActiveRecord::Base.transaction do
      kycs.each do |kyc| 
        mis_sell += (((datum[kyc.id] || 0)/total_balance) * campaign.mis_amount).to_i
      end
    end
    campaign.total_btc = total_balance
    campaign.mis_sell = mis_sell
    campaign.save
    redirect_to campaign_operator_home_index_path(campaign)
  end

  def reload
    @setting = Setting.last
    @transactions = transaction_service.cal_balance(@setting, Transaction.all)
    total_balance = @transactions.sum(:value)
    datum = @transactions.group(:kyc_address_id).sum(:value)
    kycs = KycAddress.where(id: datum.keys)
    ActiveRecord::Base.transaction do
      kycs.each {|kyc| kyc.update(btc_amount: datum[kyc.id] || 0, mis_amount: (((datum[kyc.id] || 0)/total_balance) * TOTAL_TOKEN).to_i)}
    end
    redirect_to operator_home_index_path
  end

  def amount
    @setting = Setting.last
    @transactions = TransactionsService.new.cal_balance(@setting, Transaction.all)
    @total_balance = @transactions.sum(:value)
    result = []
    datum = @transactions.group(:kyc_address_id).sum(:value)
    kycs = KycAddress.where(id: datum.keys).pluck(:mis_address)
    values = datum.values

    zipped = kycs.zip values
    zipped.each {|data| result.push({address: data[0], value: ((data[1]/@total_balance) * TOTAL_TOKEN).to_i})}
    render json: {datum: JSON.dump(result)}
  end

  private

  def set_campaigns
    @campaigns = Campaign.all
  end
  def transaction_service
    @transaction_service ||= TransactionsService.new
  end
end

