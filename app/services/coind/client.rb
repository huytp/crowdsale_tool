class Coind::Client

  def options
    @api.options
  end

  def initialize(options)
    @api = Coind::API.new(options)
  end

  # Returns the block count of the latest block in the longest block chain.
  def getnewaddress
    @api.request 'getnewaddress'
  end
  def getblockcount
    @api.request 'getblockcount'
  end

  def getblockhash(block_id)
    @api.request 'getblockhash', block_id
  end

  def getblock block_hash
    @api.request 'getblock', block_hash
  end

  # Get detailed information about +txid+
  def gettransaction(txid)
    @api.request 'gettransaction', txid
  end

  # version 0.7 Returns raw transaction representation for given transaction id.
  def getrawtransaction(txid, verbose = 0)
    @api.request 'getrawtransaction', txid, verbose
  end
  
  # version 0.7 Produces a human-readable JSON object for a raw transaction.
  def decoderawtransaction(transaction)
    @api.request 'decoderawtransaction', transaction
  end


  alias get_transaction gettransaction
  alias block_count getblockcount
  alias transaction gettransaction
end