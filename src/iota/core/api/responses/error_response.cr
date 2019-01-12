module Iota
  class Core
    module Api
      module Responses
        class ErrorResponse
          JSON.mapping(
            duration: Int64,
            error: String
          )
        end
      end
    end
  end
end
