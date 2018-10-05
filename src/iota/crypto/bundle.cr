module IOTA
  module Crypto
    class Bundle

      def initialize()
        @bundle = Array(T).new
      end

      # TODO: Write
      def add_entry(signature_message_length, address, value, tag, timestamp, index)
        # (0..signature_message_length.size).step(-1) do |i|
      end

      # TODO: Write
      def add_trytes(signature_fragments)
      end

      # TODO: Write
      def finalize
      end

      # TODO: Write
      def normalized_bundle(bundle_hash)
      end
    end
  end
end
