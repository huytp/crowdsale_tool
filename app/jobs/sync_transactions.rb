require 'sidekiq-scheduler'

class SyncTransactions
  include Sidekiq::Worker

  def perform
    TransactionsService.new.save_transactions
  end

end
