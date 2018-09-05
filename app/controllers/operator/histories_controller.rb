class Operator::HistoriesController < ApplicationController
  def index
    if params[:key] && params[:key] != ""
      kyc = KycAddress.where("email like :k OR address like :k OR mis_address like :k",k: "%#{params[:key]}%").first
      if kyc.present?
        @histories = kyc.histories.page(params[:page])
      else
        @histories = History.none.page(params[:page])
      end
    else
     @histories = History.all.page(params[:page])
   end
  end
end
