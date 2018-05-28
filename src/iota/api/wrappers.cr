module IOTA
  module API
    module Wrappers
      # TODO: write
      def get_transactions_objects(hashes)
      end

      # TODO: write
      def find_transaction_objects(input)
      end

      # TODO: write
      def get_latest_inclusion(hashes)
      end

      # TODO: write
      def store_and_broadcast(trytes)
      end

      # TODO: write
      def send_trytes(trytes, depth, min_weight_magnitude, options)
      end

      # TODO: write
      def send_transfer(seed, depth, min_weight_magnitude, transfers, options)
      end

      # TODO: write
      def promote_transaction(tail, depth, min_weight_magnitude, transfers, params)
      end

      # TODO: write
      def replay_bundle(tail, depth, min_weight_magnitude)
      end

      # TODO: write
      def broadcast_bundle(tail)
      end

      # TODO: write
      private def _new_address(seed, index, security, checksum)
      end

      # TODO: write
      def get_new_address(seed, options)
      end

      # TODO: write
      def get_inputs(seed, options)
      end

      # TODO: write
      def prepare_transfers(seed, transfers, options)
      end

      # TODO: write
      def traverse_bundle(trunk_tx, bundle_hash, bundle)
      end

      # TODO: write
      def get_bundle(trunk_tx, bundle_hash, bundle)
      end

      # TODO: write
      private def _bundles_from_addresses(addresses, inclusion_states)
      end

      # TODO: write
      def get_transfers(seed, options)
      end

      # TODO: write
      def get_account_data(seed, options)
      end

      # TODO: write
      def is_reattachable(input_addresses)
      end

      # TODO: write
      def is_promotable(tail)
      end

      # TODO: write
      def were_addresses_spent_from(addresses)
      end
    end
  end
end
