module IOTA
  module API
    module Helpers
      module BatchSend
        def batched_send(command)
          available_keys = %w[addresses hashes transactions]

          key_mapping = {
            "getTrytes" => "trytes",
            "getInclusionStates" => "inclusion_states",
            "getBalances" => "balances"
          }

        end
      end
    end
  end
end
