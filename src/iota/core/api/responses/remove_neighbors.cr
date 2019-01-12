module Iota
  class Core
    module Api
      module Responses
        class RemoveNeighbors
          JSON.mapping(
            duration: Int64,
            removedNeighbors: Int64
          )
        end
      end
    end
  end
end
