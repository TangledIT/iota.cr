module IOTA
  module Utils
    class Broker
      def initialize(provider = String.new, token = String.new, timeout = 120)
        @provider = provider || ""
        @token = token || ""
        @timeout = (timeout && timeout.to_i > 0) ? timeout : 0
      end
    end
  end
end
