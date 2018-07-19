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

      def absorb(trits, offset = 0, length = nil)
        pad = trits.size % Curl::HASH_LENGTH != 0 ? trits.size % Curl::HASH_LENGTH : Curl::HASH_LENGTH
        trits.concat([0] * (Curl::HASH_LENGTH - pad))

        length = trits.size if length.nil?

        raise "Illegal length provided" if (length && ((length % 243) != 0))

        update_string = String.new

        while offset < length
         limit = [offset + Curl::HASH_LENGTH, length].min

         trits[limit - 1] = 0 if limit - offset == Curl::HASH_LENGTH

          signed_bytes = Converter.convert_to_bytes(trits[offset...limit])
          unsigned_bytes = signed_bytes.map{ |b| Converter.convert_sign(b) }

          bytes_slice = Slice.new(unsigned_bytes.to_unsafe, unsigned_bytes.size)
          update_string += String.new(bytes_slice)

          @k.update(update_string)

          offset = offset + Curl::HASH_LENGTH
        end
      end

      def squeeze(trits, offset = 0, length = nil)
        pad = trits.size % Curl::HASH_LENGTH != 0 ? trits.size % Curl::HASH_LENGTH : Curl::HASH_LENGTH
        trits.concat([0] * (Curl::HASH_LENGTH - pad))

        length = trits.size > 0 ? trits.size : Curl::HASH_LENGTH if length.nil?

        raise "Illegal length provided" if (length && ((length % 243) != 0))

        update_string = String.new

        while offset < length
          unsigned_hash = @k.result

          signed_hash = unsigned_hash.map { |b| Converter.convert_sign_i32(b.to_i32) }

          trits_from_hash = Converter.convert_to_trits(signed_hash)

          trits_from_hash[Curl::HASH_LENGTH - 1] = 0

          limit = [Curl::HASH_LENGTH, length - offset].min

          if trits.size == 0
            trits = trits_from_hash[0...limit]
          else
            trits = trits + trits_from_hash[0...limit]
          end

          flipped_bytes = unsigned_hash.map{ |b| Converter.convert_sign(~b.to_i32) }

          update_string += String.new(flipped_bytes)
          @k.update(update_string)

          offset = offset + Curl::HASH_LENGTH
        end
        trits
      end
    end
  end
end
