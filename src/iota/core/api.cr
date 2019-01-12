require "./api/*"
require "./api/responses/*"

module Iota
  class Core
    module Api
      include GetNodeInfo
      include GetNeighbors
      include AddNeighbors
      include RemoveNeighbors
      include GetTips
      include FindTransactions
      include GetTrytes
      include GetBalances
      include GetTransactionsToApprove
      include AttachToTangle
      include BroadcastTransactions
      include StoreTransactions
      include WereAddressesSpentFrom
      include InterruptAttachingToTangle
    end
  end
end
