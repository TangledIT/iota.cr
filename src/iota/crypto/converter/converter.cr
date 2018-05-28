module IOTA
  module Crypto
    module Converter
      RADIX = 3
      RADIX_BYTES = 256
      MAX_TRIT_VALUE = 1
      MIN_TRIT_VALUE = -1
      BYTE_HASH_LENGTH = 48

      TRYTES_ALPHABET = "9ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      TRYTES_TRITS = [
        [ 0,  0,  0],
        [ 1,  0,  0],
        [-1,  1,  0],
        [ 0,  1,  0],
        [ 1,  1,  0],
        [-1, -1,  1],
        [ 0, -1,  1],
        [ 1, -1,  1],
        [-1,  0,  1],
        [ 0,  0,  1],
        [ 1,  0,  1],
        [-1,  1,  1],
        [ 0,  1,  1],
        [ 1,  1,  1],
        [-1, -1, -1],
        [ 0, -1, -1],
        [ 1, -1, -1],
        [-1,  0, -1],
        [ 0,  0, -1],
        [ 1,  0, -1],
        [-1,  1, -1],
        [ 0,  1, -1],
        [ 1,  1, -1],
        [-1, -1,  0],
        [ 0, -1,  0],
        [ 1, -1,  0],
        [-1,  0,  0]
      ]

      def self.trits(input, state = nil)
        trits = state || Array(Int32).new
        if input.is_a?(Int32)
          absolute_value = input < 0 ? -input : input

          while absolute_value > 0
            remainder = absolute_value % 3
            absolute_value = (absolute_value / 3).floor

            if remainder > 1
              remainder = -1
              absolute_value += 1
            end

            trits[trits.size] = remainder
          end
          if input < 0
            (0..trits.size).step(1) do |i|
              trits[i] = -trits[i]
            end
          end
        else
          (0..input.size).step(1) do |i|
            char = input.to_s[i]
            index = TRYTES_ALPHABET.index(input.char_at(i))
            trits[i * 3] = TRYTES_TRITS[index][0]
            trits[i * 3 + 1] = TRYTES_TRITS[index][1]
            trits[i * 3 + 2] = TRYTES_TRITS[index][2]
          end
        end
        trits
      end

      def self.trytes(trits)
        trytes = ""
        (0..trits.size).step(3) do |i|
          (0..TRYTES_ALPHABET.size).step(1) do |j|
            if TRYTES_TRITS[j][0] === trits[i] &&
               TRYTES_TRITS[j][1] === trits[i + 1] &&
               TRYTES_TRITS[j][2] === trits[i + 2]

              trytes += TRYTES_ALPHABET.char_at(j)
              break
            end
          end
        end
        trytes
      end

      def self.value(trits)
        return_value = 0
        (0..trits.size).step(-1) do |i|
          return_value = return_value * 3 + trits[i]
        end
        return_value
      end

      def self.from_value(value)
        destination = Array(Int32).new
        absolute_value = value < 0 ? -value : value
        i = 0

        while absolute_value > 0
          remainder = absolute_value % RADIX
          absolute_value = (absolute_value / RADIX).floor

          if remainder > MAX_TRIT_VALUE
            remainder = MIN_TRIT_VALUE
            absolute_value += 1
          end

          destination[i] = remainder
          i += 1
        end

        if value < 0
          (0..destination.size).step(1) do |i|
            destination[i] = destination[i] === 0 ? 0 : destination[i]
          end
        end

        destination
      end
    end
  end
end
