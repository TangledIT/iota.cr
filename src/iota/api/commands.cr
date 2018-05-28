module IOTA
  module API
    class Commands

      def attach_to_tangle(trunk_transaction, branch_transaction, min_weight_magnitude, trytes)
        {
          "command"            => "attachToTangle",
          "trunkTransaction"   => trunk_transaction,
          "branchTransaction"  => branch_transaction,
          "minWeightMagnitude" => min_weight_magnitude,
          "trytes"             => trytes,
        }
      end

      def find_transactions(search_values)
        command = {
          "command" => "findTransactions",
          "bundles" => Array(String).new,
        }
        command.merge!(search_values)
      end

      def get_balances(addresses, threshold)
        {
          "command"   => "getBalances",
          "addresses" => addresses,
          "threshold" => threshold,
        }
      end

      def get_inclusion_states(transactions, tips)
        {
          "command"      => "getInclusionStates",
          "transactions" => transactions,
          "tips"         => tips,
        }
      end

      def get_node_info
        {"command" => "getNodeInfo"}
      end

      def get_neighbors
        {"command" => "getNeighbors"}
      end

      def add_neighbors(uris)
        {
          "command" => "addNeighbors",
          "uris"    => uris,
        }
      end

      def remove_neighbors(uris)
        {
          "command" => "removeNeighbors",
          "uris"    => uris,
        }
      end

      def get_tips
        {"command" => "getTips"}
      end

      def get_transactions_to_approve(depth, reference = nil)
        {
          "command" => "getTransactionsToApprove",
          "depth"   => depth,
        }.merge(reference.nil? ? {} of String => String : {"reference" => reference})
      end

      def get_trytes(hashes)
        {
          "command" => "getTrytes",
          "hashes"  => hashes,
        }
      end

      def interrupt_attaching_to_tangle
        {"command" => "interruptAttachingToTangle"}
      end

      def broadcast_transactions(trytes)
        {
          "command" => "broadcastTransactions",
          "trytes"  => trytes,
        }
      end

      def store_transactions(trytes)
        {
          "command" => "storeTransactions",
          "trytes"  => trytes,
        }
      end

      def check_consistency(hashes)
        {
          "command" => "checkConsistency",
          "tails"   => hashes,
        }
      end

      def were_addresses_spent_from(addresses)
        {
          "command" => "wereAddressesSpentFrom",
          "addresses"   => addresses,
        }
      end
    end
  end
end
