module IOTA
  module Utils
    module Ascii
      TRYTE_VALUES = "9ABCDEFGHIJKLMNOPQRSTUVWXYZ"

      def to_trytes(input)
        return nil if !@validator.is_string?(input)

        trytes = ""
        (0..input.to_s.size - 1).step(1) do |i|
          char = input.to_s[i]

          ascii_value = char.bytes.map(&.to_i).sum

          return nil if ascii_value > 255

          first_value = ascii_value % 27
          second_value = (ascii_value - first_value) / 27

          trytes_value = TRYTE_VALUES[first_value].to_s + TRYTE_VALUES[second_value].to_s
          trytes += trytes_value
        end
        trytes
      end

      def from_trytes(input)
        return nil if !@validator.is_trytes?(input) || input.to_s.size % 2 != 0

        output_string = ""
        (0...input.to_s.size - 1).step(2) do |i|
          trytes = input.to_s[i].to_s + input.to_s[i + 1].to_s

          first_value = TRYTE_VALUES.index(trytes[0])
          second_value = TRYTE_VALUES.index(trytes[1])

          return if first_value.nil? || second_value.nil?
          decimal_value = first_value + second_value * 27

          output_string += decimal_value.chr
        end
        output_string
      end
    end
  end
end
