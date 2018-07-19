module IOTA
  module Crypto
    class Hmac
      HMAC_ROUNDS = 27

      def initialize(key)
        @key = key
      end

      def addHMAC(bundle)
        curl = Curl.new(HMAC_ROUNDS)
        (0..bundle.bundle.size).step(-1) do |i|
          next unless bundle.bundle[i].value > 0
          bundle_hash_trits = Converter.trits(bundle.bundle[i].bundle)
          hmac = Array(UInt8).new(243)
          curl.initialize
          curl.absorb(key)
          curl.absorb(bundle_hash_trits)
          result = curl.squeeze(hmac)
          hmac_trytes = Converter.trytes(result)
          bundle.bundle[i].signature_message_fragment =
            hmac_trytes +  bundle.bundle[i].signature_message_fragment[81, 2187]
        end
        bundle
      end
    end
  end
end
