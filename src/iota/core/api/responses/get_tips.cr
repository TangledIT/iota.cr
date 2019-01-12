module Iota
  class Core
    module Api
      module Responses
        class GetTips
          JSON.mapping(
            duration: Int64,
            hashes: Array(String)
          )
        end
      end
    end
  end
end
