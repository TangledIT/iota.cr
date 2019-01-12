module Iota
  class Core
    module Api
      module Responses
        class GetTrytes
          JSON.mapping(
            duration: Int64,
            trytes: Array(String)
          )
        end
      end
    end
  end
end
