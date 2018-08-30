class CurrencyService
  def self.start_sync
    @bitcoin_usd = TransactionsService.new.parse_json(BITCOIN_RATE_URL).try(:[], "data").try(:[], "1").try(:[], "quotes").try(:[], "USD").try(:[], "price")
    Setting.last.update(current_rate: @bitcoin_usd)
  end
end