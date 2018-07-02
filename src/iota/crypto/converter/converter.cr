require "big"

module IOTA
  module Crypto
    module Converter
      RADIX            =   3
      RADIX_BYTES      = 256
      MAX_TRIT_VALUE   =   1
      MIN_TRIT_VALUE   =  -1
      BYTE_HASH_LENGTH =  48

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
        trits = state || Hash(Int32, Int32).new
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
          (0..input.size - 1).step(1) do |i|
            index = TRYTES_ALPHABET.index(input.char_at(i)).as(Int32)
            trits[i * 3] = TRYTES_TRITS[index][0]
            trits[i * 3 + 1] = TRYTES_TRITS[index][1]
            trits[i * 3 + 2] = TRYTES_TRITS[index][2]
          end
        end
        trits.values
      end

      def self.trytes(trits)
        trytes = ""
        (0..trits.size - 1).step(3) do |i|
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

      def self.convert_to_bytes(trits)
        bigint = convert_base_to_bigint(trits, 3)
        bytes_k = convert_bigint_to_bytes(bigint)
        bytes_k
      end

      def self.convert_to_trits(bytes)
        big_int = convert_bytes_to_big_int(bytes)
        trits = convert_big_int_to_base(big_int, 3, Curl::HASH_LENGTH)
        trits
      end

      def self.convert_base_to_big_int(array, base)
        bigint = 0
        (0...array.size).step(1) do |i|
          bigint += array[i] * (base ** i)
        end
        bigint
      end

      def self.convert_base_to_bigint(array, base)
        bigint = BigInt.new
        (0..array.size - 1).step(1) do |i|
          bigint = bigint + (array[i] * (base ** i))
        end
        bigint
      end

      def self.convert_big_int_to_base(big_int, base, length)
        result = Array(Int32).new

        is_negative = big_int < 0
        quotient = big_int.abs

        max, _ = (is_negative ? base : base-1).divmod(2)

        length.times do
          quotient, remainder = quotient.divmod(base)

          if remainder > max
            # Lend 1 to the next place so we can make this digit negative.
            quotient += 1
            remainder -= base
          end

          remainder = -remainder if is_negative

          result << remainder
        end

        result
      end

      def self.convert_bigint_to_bytes(big)
        bytes_array_temp = Array(UInt8).new
        (0..48).step(1) do |pos|
          bytes_array_temp << ((big.abs.to_u8 >> pos * 8) % (1 << 8)).to_u8
        end

        bytes_array = bytes_array_temp.reverse.map { |x| x <= 0x7F ? x : x - 0x100 }

        if big < 0
          bytes_array = bytes_array.map { |val| ~val }

          (0..bytes_array.size).step(1) do |pos|
            add = (bytes_array[pos] & 0xFF) + 1
            bytes_array[pos] = add <= 0x7F ? add : add - 0x100
            break if bytes_array[pos] != 0
          end
        end

        bytes_array
      end

      def self.convert_bytes_to_big_int(array)
        # copy of array
        bytes_array = array.map { |x| x }

        # number sign in MSB
        signum = bytes_array[0] >= 0 ? 1 : -1

        if signum == -1
          # sub1
          (0...bytes_array.size).reverse_each do |pos|
            sub = (bytes_array[pos] & 0xFF) - 1
            bytes_array[pos] = sub <= 0x7F ? sub : sub - 0x100
            break if bytes_array[pos] != -1
          end

          # 1-compliment
          bytes_array = bytes_array.map { |x| ~x }
        end

        # sum magnitudes and set sign
        sum = 0
        bytes_array.reverse!.each_with_index do |v, pos|
          sum += (v & 0xFF) << pos * 8
        end

        sum * signum
      end


      def self.convert_sign(byte)
        if byte < 0
          return (256 + byte.to_u8).to_u8
        elsif byte > 127
          return (-256 + byte.to_u8).to_u8
        end
        return byte.to_u8
      end
    end
  end
end
