class Api::SyncKycController < ApplicationController
  protect_from_forgery with: :null_session
  def create
    if params[:token] == ENV["SECURE_PASS"]
      unless KycAddress.exists?(address: params[:btc_address])
        KycAddress.create(email: params[:email], address: params[:btc_address], mis_address: params[:mis_address])
        render json: {status: 200}
      else
        render json: {status: 500}
      end
    end
  end
end
