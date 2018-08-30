class TransactionsService

  def parse_json url
    require 'net/http'
    require 'json'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def save_transactions
    setting = Setting.last
    coin = Coind::Client.new({rpc_user: ENV["RPC_USER"], rpc_password: ENV["RPC_PASSWD"], rpc_host: ENV["RPC_HOST"], rpc_port: ENV["RPC_PORT"], rpc_ssl: ENV["RPC_SSL"] == "true" ? true : false})
    block_height = coin.getblockcount
    stat = Stat.last
    stat.update(count: block_height) if block_height.class == Integer
    last_height = stat.last
    unless  last_height >= block_height
      (last_height..block_height).each do |index|
        unless index == last_height
          block_hash = coin.getblockhash index
          block_info = coin.getblock block_hash.to_s
          last_height = block_info["height"]
          transaction_ids = block_info["tx"]
          time = block_info["time"]
          transaction_ids.each do |transaction_id|
            raw = coin.getrawtransaction transaction_id
            transaction_data = coin.decoderawtransaction raw
            check_at_out_address transaction_data, time, last_height, setting
          end
          stat.update(last: last_height)
          p block_info
          p "--------------------------------"
        end
      end
    end
  end

  def check_at_out_address transaction_data, time, height, setting
    current_btc = FixedCampaign.sum(:current_btc)
    vout = transaction_data["vout"]
    check = false
    out_value = 0
    vout.each do |out|
      out_addr = out.try(:[], "scriptPubKey").try(:[], "addresses").try(:[], 0)
      if out_addr
        out_value = out["value"]
        tx_hash = transaction_data["txid"]
        kyc = KycAddress.find_by_address(out_addr)
        if kyc.present?
          tx = Transaction.find_by_txid(tx_hash)
          unless tx
            new_transaction = kyc.transactions.create(value: out_value, height: height, txid: tx_hash, tx_created_at: Time.at(time.to_i))
            current_campaign = FixedCampaign.where("start_btc <= :btc AND end_btc > :btc", btc:  current_btc).first
            sum_kyc_btc = History.where(overload: false, kyc_address_id: kyc.id).sum(:value)
            if sum_kyc_btc > setting.max_btc
              kyc.histories.create(fixed_campaign_id: current_campaign.id, transaction_id: new_transaction.id, value: out_value, overload: true)
            else
              total_after_buy = sum_kyc_btc + out_value
              allow_value = out_value
              if total_after_buy > setting.max_btc
                overload_value = total_after_buy - setting.max_btc
                allow_value = out_value - overload_value
                kyc.histories.create(fixed_campaign_id: current_campaign.id, transaction_id: new_transaction.id, value: overload_value, overload: true)
              end
              total_btc = allow_value + current_btc
              current_campaign_value = current_campaign.current_btc
              if total_btc > current_campaign.end_btc
                overload = total_btc - current_campaign.end_btc
                kyc.histories.create(fixed_campaign_id: current_campaign.id, transaction_id: new_transaction.id, value: allow_value - overload)
                current_campaign.update(current_btc: current_campaign_value + allow_value - overload)
                next_campaign = FixedCampaign.where("start_btc <= :btc AND end_btc > :btc", btc:  FixedCampaign.sum(:current_btc)).first
                if next_campaign.nil?
                  kyc.histories.create(fixed_campaign_id: OVERLOAD_CAMPAIGN_ID, transaction_id: new_transaction.id, value: overload, overload: true)
                else
                  next_campaign_value = next_campaign.current_btc
                  kyc.histories.create(fixed_campaign_id: next_campaign.id, transaction_id: new_transaction.id, value: overload)
                  next_campaign.update(current_btc: next_campaign_value + overload)
                end
              else
                current_campaign.update(current_btc: current_campaign_value + allow_value)
                kyc.histories.create(fixed_campaign_id: current_campaign.id, transaction_id: new_transaction.id, value: allow_value)
              end
            end
          end
        end
      end
    end
  end

  def cal_balance_campaign setting, transactions, campaign
    block_height = Stat.last.count + 1
    if setting.require_confirmation
      transactions = transactions.where("height <= ?", block_height - setting.min_confirmation).where("tx_created_at >= ? AND tx_created_at < ?", campaign.time_start, campaign.time_end)
    end
    transactions
  end

  def cal_balance setting, transactions
    block_height = Stat.last.count + 1
    if setting.require_confirmation
      transactions = transactions.where("height <= ?", block_height - setting.min_confirmation)
    end
    transactions
  end
end