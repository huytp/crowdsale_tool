require 'sidekiq-scheduler'

class SyncCurrency
  include Sidekiq::Worker

  def perform
    CurrencyService.start_sync
  end

end
