module IOTA
  module Crypto
    class Curl
      NUMBER_OF_ROUNDS =  81
      HASH_LENGTH      = 243
      STATE_LENGTH     = 3 * HASH_LENGTH
      TRUTH_TABLE = [1, 0, -1, 1, -1, 0, -1, 1, 0]

      def initialize(rounds = nil)
        @rounds = NUMBER_OF_ROUNDS
        @state = Array(Int32).new
        reset
      end

      def reset
        @state = [0] * STATE_LENGTH
      end

      def absorb(trits)
        length = trits.size
        offset = 0

        while offset < length
          start = offset
          stop = [start + HASH_LENGTH, length].min

          ar_end = start + (stop - start)

          @state[0..stop-start] = trits[start..ar_end]
          transform

          offset = offset + HASH_LENGTH
        end
      end

      def squeeze(trits)
        trits[0...HASH_LENGTH] = @state[0..HASH_LENGTH]
        transform
      end

      def transform
        previous_state = @state[0..@state.size]
        new_state = @state[0..@state.size]

        index = 0
        round = 0

        p previous_state

        while round < @rounds
          previous_trit = previous_state[index]

          pos = 0
          while true
            index += (index < 365) ? 364 : -365
            new_trit = previous_state[index]
            # new_state[pos] = TRUTH_TABLE[previous_trit + (3 * new_trit) + 4]
            #previous_trit = new_trit
            pos += 1
            break if pos >= STATE_LENGTH
          end

        #  previous_state = new_state
        #  new_state = new_state[0..new_state.size]
          round += 1
        end

        @state = new_state
      end
    end
  end
end
