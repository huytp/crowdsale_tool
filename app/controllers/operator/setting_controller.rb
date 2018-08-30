class Operator::SettingController < ApplicationController
  before_action :set_setting, only: [:index, :edit, :update]
  before_action :set_campaign, only: [:edit_campaign, :destroy_campaign, :update_campaign]
  before_action :set_fixed_campaign, only: [:edit_fixed_campaign, :destroy_fixed_campaign, :update_fixed_campaign]
  def index
    @campaigns = Campaign.all
    @fixed_campaign = FixedCampaign.all
    @stat = Stat.first
  end

  def update
    @setting.update(setting_params)
    flash[:success] = "Updated successfully"
    redirect_to operator_setting_index_path
  end

  def new_campaign
    @campaign = Campaign.new
  end

  def new_fixed_campaign
    @campaign = FixedCampaign.new
  end

  def create_campaign
    @campaign = Campaign.new(campaign_params)
    flash[:success] = "Created successfully"
    @campaign.save
    redirect_to operator_setting_index_path
  end

  def create_fixed_campaign
    @campaign = FixedCampaign.new(fixed_campaign_params)
    flash[:success] = "Created successfully"
    @campaign.save
    redirect_to operator_setting_index_path
  end

  def edit_campaign
  end

  def update_campaign
    @campaign.update(campaign_params)
    flash[:success] = "Updated successfully"
    redirect_to operator_setting_index_path
  end

  def update_fixed_campaign
    @campaign.update(fixed_campaign_params)
    flash[:success] = "Updated successfully"
    redirect_to operator_setting_index_path
  end

  def destroy_campaign
    @campaign.destroy
    flash[:success] = "Deleted"
    redirect_to operator_setting_index_path
  end

  def destroy_fixed_campaign
    @campaign.destroy
    flash[:success] = "Deleted"
    redirect_to operator_setting_index_path
  end

  private

  def campaign_params
    params.require(:campaign).permit(:name, :time_start, :time_end, :mis_amount)
  end

  def fixed_campaign_params
    params.require(:fixed_campaign).permit(:name, :start_btc, :end_btc, :btc_to_mis)
  end

  def set_campaign
    @campaign = Campaign.find_by_id(params[:id])
  end

  def set_fixed_campaign
    @campaign = FixedCampaign.find_by_id(params[:id])
  end

  def setting_params
    params.require(:setting).permit(:min_confirmation, :require_confirmation, :max_btc)
  end

  def set_setting
    if Setting.none?
      Setting.create(time_finish: "2018-06-30", min_confirmation: 4, require_confirmation: true, require_time: false, current_rate: 0)
    end
    @setting = Setting.last
  end
end