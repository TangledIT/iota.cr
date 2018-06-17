module IOTA
  module Crypto
    class Curl
      NUMBER_OF_ROUNDS =  81
      HASH_LENGTH      = 243
      STATE_LENGTH     = 3 * HASH_LENGTH

      def initialize(rounds)
      end

      def init(state, length)
      end

      def reset
      end

      def absorb(trits, offset, length)
      end

      def squeeze(trits, offset, length)
      end

      def transform
      end
    end
  end
end
