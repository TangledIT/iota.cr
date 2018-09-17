module IOTA
  module Crypto
    module Signing
      HASH_LENGTH = Curl::HASH_LENGTH

      def self.key(seed, index, security)
        key = Array(Int32).new
        offset = 0
        buffer = Array(Int32).new

        (0...index).step(1) do |i|
          (0...seed.size).step(1) do |j|
            p j
            seed[j] += 1

            if seed[j] > 1
              seed[j] = -1
            else
              break
            end
          end
        end

        p seed

        kerl = Kerl.new
        kerl.absorb(seed, 0, seed.size)
        trots = kerl.squeeze(seed, 0, seed.size)
        kerl.reset
        trots2 = kerl.absorb(seed, 0, seed.size)

        # security.times do
        #   (0...27).step(1) do |i|
        #     kerl.squeeze(buffer, 0, seed.size)
        #     (0...HASH_LENGTH).step(1) do |j|
        #       key[offset] = buffer[j]
        #       offset += 1
        #     end
        #   end
        # end
        key
      end

      def self.digests(key)
        digests_array = Array(String).new
        buffer = Array(Int32).new

        (0...(@key.size / 6561).floor).step(1) do |i|
          key_fragment = @key.slice(i * 6561, 6561)

          (0...27).step(1) do |j|
            buffer = key_fragment.slice(j * HASH_LENGTH, HASH_LENGTH);

            (0...26).step(1) do |k|
              kKerl = Kerl.new
              kKerl.absorb(buffer, 0, buffer.size)
              kKerl.squeeze(buffer, 0, HASH_LENGTH)
            end

            (0...HASH_LENGTH).step(1) do |k|
              key_fragment[j * HASH_LENGTH + k] = buffer[k]
            end
          end

          kerl = Kerl.new
          kerl.absorb(key_fragment, 0, key_fragment.size)
          kerl.squeeze(buffer, 0, HASH_LENGTH)

          (0...HASH_LENGTH).step(1) do |j|
            digests_array[i * HASH_LENGTH + j] = buffer[j];
          end
        end
        digests_array
      end

      def self.address(digests)
        address_trits = Array(Int32).new

        kerl = Kerl.new

        kerl.absorb(digests, 0, digests.size)
        kerl.squeeze(address_trits, 0, HASH_LENGTH)

        address_trits
      end

      def self.digest(normalized_bundle_fragment, signature_fragment)
        buffer = Array(Int32).new
        kerl = Kerl.new

        (0...27).step(1) do |i|
          buffer = signature_fragment.slice(i * HASH_LENGTH, HASH_LENGTH)

          j = normalized_bundle_fragment[i] + 13

          while j > 0
            jKerl = Kerl.new
            jKerl.absorb(buffer, 0, buffer.size)
            jKerl.squeeze(buffer, 0, HASH_LENGTH)
            j -= 1
          end

          kerl.absorb(buffer, 0, buffer.size)
        end

        kerl.squeeze(buffer, 0, HASH_LENGTH)
        buffer
      end

      def self.signature_fragment(normalized_bundle_fragment, key_fragment)
        signature_fragment = key_fragment.slice(0, key_fragment.size)
        hash = Array(String).new

        kerl = Kerl.new

        (0...27).step(1) do |i|
          hash = signature_fragment.slice(i * HASH_LENGTH, HASH_LENGTH)

          (0...13-normalized_bundle_fragment[i]).step(1) do |j|
            kerl.reset
            kerl.absorb(hash, 0, hash.size)
            kerl.squeeze(hash, 0, HASH_LENGTH)
          end

          (0...HASH_LENGTH).step(1) do |j|
            signature_fragment[i * HASH_LENGTH + j] = hash[j]
          end
        end

        signature_fragment
      end

      def self.validate_signatures(expected_address, signature_fragments, bundle_hash)
        if !bundle_hash
          raise "Invalid bundle hash provided"
        end

        bundle = Bundle.new

        normalized_bundle_fragments = Array(String).new
        normalized_bundle_hash = bundle.normalized_bundle(bundle_hash)

        # Split hash into 3 fragments
        (0...3).step(1) do |i|
          normalized_bundle_fragments[i] = normalized_bundle_hash.slice(i * 27, 27)
        end

        # Get digests
        digests = Array(String).new
        (0...signature_fragments.size).step(1) do |i|
          digestBuffer = digest(normalized_bundle_fragments[i % 3], Converter.trits(signature_fragments[i]))

          (0...HASH_LENGTH).step(1) do |j|
            digests[i * 243 + j] = digestBuffer[j]
          end
        end

        address_trits = address(digests)
        address = Converter.trytes(address_trits)

        expected_address == address
      end
    end
  end
end
