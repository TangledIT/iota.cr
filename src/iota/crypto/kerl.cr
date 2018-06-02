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
        while offset < length
          limit = (length < Curl::HASH_LENGTH ? length : Curl::HASH_LENGTH)
          trit_state = trits

          offset = offset + Curl::HASH_LENGTH

          words_to_absorb = Converter::Words.trits_to_words(trit_state)

          @k.update(words_to_absorb)
        end
      end

      def squeeze(trits, offset, length)
        raise "Illegal length provided" if (length && ((length % 243) != 0))
        while offset < length
          k_copy = @k.clone
          final = k_copy.result

          trit_state = Converter::Words.words.words_to_trits(final.words)

          i = 0
          limit = (length < Curl::HASH_LENGTH ? length : Curl::HASH_LENGTH)

          while i < limit
            trits[offset += 1] = trit_state[i += 1]
          end

          reset

          (0..final.words.size).step(1) do |i|
            final.words[i] = final.words[i] ^ 0xFFFFFFFF
          end

          @k.update(final)
        end
      end
    end
  end
end
