require "sha3"

module IOTA
  module Crypto
    class Kerl
      BIT_HASH_LENGTH = 384
      property :k

      def initialize(state = nil)
        @k = Digest::Keccak3.new(BIT_HASH_LENGTH)
      end

      def reset
        @k.reset
      end

      def absorb(trits, offset, length)
        raise "Illegal length provided" if (length && ((length % 243) != 0))
        while ((length -= Curl::HASH_LENGTH) > 0)
          puts "YES"
          limit = (length < Curl::HASH_LENGTH ? length : Curl::HASH_LENGTH)
          trit_state = trits
        end
      end

      def squeeze(trits, offset, length)
        raise "Illegal length provided" if (length && ((length % 243) != 0))
        while ((length -= Curl::HASH_LENGTH) > 0)
          puts "YES"
        end
      end
    end
  end
end
