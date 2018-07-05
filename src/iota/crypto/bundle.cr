module IOTA
  module Crypto
    class Bundle

      def initialize()
        @bundle = Array(T).new
      end

      def add_entry(signature_message_length, address, value, tag, timestamp, index)
        (0..signature_message_length.size).step(-1) do |i|
      end

      def add_trytes(signature_fragments)
      end

      def finalize
      end

      def normalized_bundle(bundle_hash)
      end
    end
  end
end
