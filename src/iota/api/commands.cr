module IOTA
  module API
    class Commands
      def find_transactions(search_values)
        command = {
          command: "findTransactions",
        }

        search_values.each { |k, v| command[k] = v }
        command
      end

      def get_balances(addresses, threshold)
        {
          command:   "getBalances",
          addresses: addresses,
          threshold: threshold,
        }
      end

      def get_trytes(hashes)
        {
          command: "getTrytes",
          hashes:  hashes,
        }
      end

      def get_inclusion_states(transactions, tips)
        {
          command:      "getInclusionStates",
          transactions: transactions,
          tips:         tips,
        }
      end

      def get_node_info
        {command: "getNodeInfo"}
      end

      def get_neighbors
        {command: "getNeighbors"}
      end

      def add_neighbors(uris)
        {
          command: "addNeighbors",
          uris:    uris,
        }
      end

      def remove_neighbors(uris)
        {
          command: "removeNeighbors",
          uris:    uris,
        }
      end

      def get_tips
        {command: "getTips"}
      end

      def get_transactions_to_approve(depth, reference = nil)
        {
          command: "getTransactionsToApprove",
          depth:   depth,
        }.merge(reference.nil? ? {} of Symbol => String : {reference: reference})
      end

      def attach_to_tangle(trunkTransaction, branchTransaction, minWeightMagnitude, trytes)
        {
          command:            "attachToTangle",
          trunkTransaction:   trunkTransaction,
          branchTransaction:  branchTransaction,
          minWeightMagnitude: minWeightMagnitude,
          trytes:             trytes,
        }
      end

      def interrupt_attaching_to_tangle
        {command: "interruptAttachingToTangle"}
      end

      def broadcast_transactions(trytes)
        {
          command: "broadcastTransactions",
          trytes:  trytes,
        }
      end

      def store_transactions(trytes)
        {
          command: "storeTransactions",
          trytes:  trytes,
        }
      end

      def check_consistency(tails)
        {
          command: "checkConsistency",
          tails:   tails,
        }
      end
    end
  end
end
