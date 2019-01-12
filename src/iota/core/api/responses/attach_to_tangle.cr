module Iota
  class Core
    module Api
      module Responses
        class AttachToTangle
          JSON.mapping(
            trytes: Array(String)
          )
        end
      end
    end
  end
end
