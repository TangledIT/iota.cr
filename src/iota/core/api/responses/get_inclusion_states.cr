module Iota
  class Core
    module Api
      module Responses
        class GetInclusionStates
          JSON.mapping(
            duration: Int64,
            states: Array(Bool)
          )
        end
      end
    end
  end
end
