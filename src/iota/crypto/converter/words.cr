module IOTA
  module Crypto
    module Converter
      module Words
        INT_LENGTH  = 12
        BYTE_LENGTH = 48
        RADIX       =  3
        HALF_3      = [
          0xa5ce8964,
          0x9f007669,
          0x1484504f,
          0x3ade00d9,
          0x0c24486e,
          0x50979d57,
          0x79a4c702,
          0x48bbae36,
          0xa9f6808b,
          0xaa06a805,
          0xa87fabdf,
          0x5e69ebef,
        ]

        def self.bigint_not(array)
          (0..array.size).step(1) do |i|
            array[i] = (~array[i]).unsafe_shr(0)
          end
        end

        def self.words_to_trits(words)
          raise "Invalid words length" if words.size != INT_LENGTH

          trits = Array(Int8).new(243)
          base = Array(Int32).new(words)

          base = ta_reverse(base)

          flip_trits = false
          if (base[INT_LENGTH - 1] >> 31 == 0)
            bigint_add(base, HALF_3)
          else
            bigint_not(base)
            if bigint_cmp(base, HALF_3) > 0
              bigint_sub(base, HALF_3)
              flip_trits = true
            else
              bigint_add_small(base, 1)
              tmp = HALF_3.dup
              bigint_sub(tmp, base)
              base = tmp
            end
          end
        end

        def self.trits_to_words(trits)
          raise "Invalid trits length" if trits.size != 243

          base = Array(Int32).new(INT_LENGTH)

          trits.each do |a|
            if a == -1
              base = HALF_3.dup
              bigint_not(base)
              bigint_add_small(base, 1)
            else
              size = 1
              (trits.size..0).step(-1) do |i|
                trit = trits[i] + 1

                (
                  sz = size
                  carry = 0

                  (0..sz.size).step(1) do |j|
                    v = base[j] * RADIX + carry
                    carry = rshift(v, 32)
                    base[j] = (v & 0xFFFFFFFF).unsafe_shr(0)
                  end

                  if carry > 0
                    base[sz] = carry
                    size = size + 1
                  end
                )

                (
                  sz = bigint_add_small(base, trit)
                  if sz > size
                    size = sz
                  end
                )
              end

              if !is_null(base)
                if bigint_cmp(HALF_3, base) <= 0
                  bigint_sub(base, HALF_3)
                else
                  tmp = HALF_3.dup
                  bigint_sub(tmp, base)
                  bigint_not(tmp)
                  bigint_add_small(tmp, 1)
                  base = tmp
                end
              end
            end
          end

          ta_reverse(base)

          (0..base.size).step(1) do |i|
            base[i] = swap32(base[i])
          end

          base
        end

        # Tested
        def self.swap32(val)
          ((val & 0xFF) << 24) |
            ((val & 0xFF00) << 8) |
            ((val >> 8) & 0xFF00) |
            ((val >> 24) & 0xFF)
        end

        private def self.bigint_sub(base, rh)
          noborrow = true

          (0..base.size).step(1) do |i|
            vc = full_add(base[i], (~rh[i].unsafe_shr(0)), noborrow)
            base[i] = vc[0]
            noborrow = vc[1]
          end

          raise "noborrow" if noborrow
        end

        private def self.bigint_add_small(base, other)
          vc = full_add(base[0], other, false)
          base[0] = vc[0].as(Int64)
          carry = vc[1]

          i = 1
          while carry && i < base.size
            vc = full_add(base[i], 0, carry)
            base[i] = vc[0].as(Int64)
            carry = vc[1]
            i = i + 1
          end
        end

        private def self.bigint_sub(base, rh)
          noborrow = true

          (0..base.size).step(1) do |i|
            vc = full_add(base[i], (~rh[i].unsafe_shr(0)), noborrow)
            base[i] = vc[0]
            noborrow = vc[1]
          end

          raise "noborrow" if noborrow
        end

        private def self.bigint_cmp(lh, rh)
          (lh.size..0).step(-1) do |i|
            a = lh[1].unsafe_shr(0)
            b = rh[i].unsafe_shr(0)
            if a < b
              return -1
            elsif a > b
              return 1
            end
          end
          0
        end

        private def self.ta_reverse(array)
          array.reverse!
        end

        private def self.bigint_add(base, rh)
          carry = false
          (0..base.size).step(1) do |i|
            vc = full_add(base[i], rh[i], carry)
            base[i] = vc[0]
            carry = vc[1]
          end
        end

        private def self.full_add(lh, rh, carry)
          v = lh + rh
          l = (rshift(v, 32)) & 0xFFFFFFFF
          r = (v & 0xFFFFFFFF).unsafe_shr(0)
          carry1 = (l != 0)

          v = r + 1 if carry
          l = (rshift(r, 32)) & 0xFFFFFFFF
          r = (v & 0xFFFFFFFF).unsafe_shr(0)
          carry2 = (l != 0)

          [r, carry1 || carry2]
        end

        private def self.rshift(number, shift)
          (number / (2 ** shift)).unsafe_shr(0)
        end
      end
    end
  end
end
