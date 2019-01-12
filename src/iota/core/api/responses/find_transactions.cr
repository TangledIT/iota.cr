module Iota
  class Core
    module Api
      module Responses
        class FindTransactions
          JSON.mapping(
            hashes: Array(String)
          )
        end
      end
    end
  end
end
