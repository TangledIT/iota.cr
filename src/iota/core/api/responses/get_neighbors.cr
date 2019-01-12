module Iota
  class Core
    module Api
      module Responses
        class GetNeighbors
          JSON.mapping(
            duration: Int64,
            neighbors: Array(Hash(String, String | Int64))
          )
        end
      end
    end
  end
end
