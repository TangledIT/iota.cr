module Iota
  class Core
    module Api
      module Responses
        class GetTransactionsToApprove
          JSON.mapping(
            duration: Int64,
            trunkTransaction: String,
            branchTransaction: String
          )
        end
      end
    end
  end
end
