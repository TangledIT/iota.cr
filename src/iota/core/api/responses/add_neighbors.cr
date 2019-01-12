module Iota
  class Core
    module Api
      module Responses
        class AddNeighbors
          JSON.mapping(
            duration: Int64,
            addedNeighbors: Int64
          )
        end
      end
    end
  end
end
