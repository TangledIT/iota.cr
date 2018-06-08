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

        #pad = (trits.size % Curl::HASH_LENGTH) || Curl::HASH_LENGTH
        #puts trits
        # trits.merge[0] * (Curl::HASH_LENGTH - pad)
        while offset < length

          stop = Math.min(offset + Curl::HASH_LENGTH, length)

          trits[stop - 1] = 0 if stop - offset == Curl::HASH_LENGTH

          selected_trits = Array(Int32).new
          (offset..stop).step(1) do |i|
            selected_trits << i
          end

          signed_nums = Converter.convert_to_bytes(trits.select!(selected_trits))

          unsigned_bytes = Array(UInt8).new
          (0..signed_nums.size - 1).step(1) do |i|
            unsigned_bytes << Converter.convert_sign(signed_nums[i])
          end

          @k.update(unsigned_bytes.to_s)

          offset = offset + Curl::HASH_LENGTH
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
