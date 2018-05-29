module IOTA
  module API
    module Wrappers
      # TODO: write
      def get_transactions_objects(hashes)
      end

      def find_transaction_objects(input)
        transactions = find_transactions(input)
        get_transactions_objects(transactions)
      end

      def get_latest_inclusion(hashes)
        node_info = get_node_info
        latest_milestone = get_node_info["latestSolidSubtangleMilestone"]
        get_inclusion_states(hashes, [latest_milestone])
      end

      def store_and_broadcast(trytes)
        store_transactions(trytes)
      end

      # TODO: write
      def send_trytes(trytes, depth, min_weight_magnitude, options)
      end

      # TODO: write
      def send_transfer(seed, depth, min_weight_magnitude, transfers, options)
      end

      def promote_transaction(tail, depth, min_weight_magnitude, transfers, params)
        if !@validator.is_hash?(tail)
          return send_data(false, "Invalid Trytes")
        end

        return send_data(false, "Inconsistent Subtangle with #{tail.to_s}") unless is_promotable(tail)

        if params["interrupt"].present?
          return send_data(nil, tail)
        end

        send_transfer(transfer[0].address, depth, min_weight_magnitude, transfer, {"reference": tail})

        sleep params["delay"] if params["delay"]

        promote_transaction(tail, depth, min_weight_magnitude, transfer, params)
      end

      def replay_bundle(tail, depth, min_weight_magnitude)
        if !@validator.is_hash?(tail)
          return send_data(false, "Invalid Trytes")
        end

        if !@validator.is_value?(depth) || !@validator.is_value?(min_weight_magnitude)
          return send_data(false, "Invalid Inputs")
        end

        bundle = get_bundle(tail)
        bundle_trytes = Array(String).new

        (0...bundle.size).step(1) do |i|
          bundle_trytes << @utils.transaction_trytes(bundle[i])
        end

        send_trytes(bundle_trytes.reverse, depth, min_weight_magnitude)
      end

      # TODO: write
      def broadcast_bundle(tail)
      end

      private def _new_address(seed, index, security, checksum)
        key = Signing.key(Converter.trits(seed), index, security)
        digests = Signing.digests(key)
        address_trits = Signing.address(digests)
        address = Converter.trytes(address_trits)

        address = @utils.add_checksum(address) if checksum
        address
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

      def is_promotable(tail)
        if !@validator.is_hash?(tail)
          return send_data(false, "Invalid Trytes")
        end

        send_command(@commands.check_consistency([tail]))
      end

      def were_addresses_spent_from(addresses)
        if addresses.is_a?(Array)
          adresses_list = addresses
        else
          adresses_list = [addresses]
        end

        (0...adresses_list.size).step(1) do |i|
          if !@validator.is_address?(adresses_list[i])
            error = "Invalid Address"
            break
          end
        end

        if error
          return send_data(false, error)
        else
          command = @commands.were_addresses_spent_from(adresses_list.map { |address| @utils.no_checksum(address) })
          send_command(command)
        end
      end
    end
  end
end
