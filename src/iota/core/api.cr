require "./api/*"

module Iota
  class Core
    module Api
      include GetNodeInfo
    end
  end
end