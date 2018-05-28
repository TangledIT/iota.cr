module IOTA
  module Crypto
    module Signing
      def self.key(seed, index, length)
      end

      def self.digests(key)
      end

      def self.address(digests)
      end

      def self.digest(normalized_bundle_fragment, signature_fragment)
      end

      def self.signature_fragment(normalized_bundle_fragment, key_fragment)
      end

      def self.validate_signatures(expected_address, signature_fragments, bundle_hash)
      end
    end
  end
end
