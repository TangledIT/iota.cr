module Iota
  class Core
    module Api
      module Responses
        class GetBalances
          JSON.mapping(
            duration: Int64,
            balances: Array(String),
            references: Array(String),
            milestoneIndex: Int64
          )
        end
      end
    end
  end
end
