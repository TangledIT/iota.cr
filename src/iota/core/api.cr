require "./api/*"
require "./api/responses/*"

module Iota
  class Core
    module Api
      include GetNodeInfo
    end
  end
end
