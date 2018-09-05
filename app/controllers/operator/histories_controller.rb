class Operator::HistoriesController < ApplicationController
  def index
    @histories = History.all.page(params[:page])
  end
end
