module IOTA
  module API
    module Wrappers
      def get_transactions_objects(hashes)
        if !@validator.is_array_of_hashes?(hashes)
          return send_data(false, "Invalid Hashes")
        end

        trytes = get_trytes(hashes)
        transaction_objects = Array(String).new

        trytes.each_with_index do |tryte, index|
          if !tryte
            transaction_objects << ""
          else
            transaction_objects << @utils.transaction_object(tryte, hashes[index])
          end
        end
        transaction_objects
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

      def send_trytes(trytes, depth, min_weight_magnitude, options)
        if !@validator.is_value?(depth)
          return send_data(false, "Invalid depth")
        end

        if !@validator.is_value(min_weight_magnitude)
          return send_data(false, "Invalid min_weight_magnitude")
        end

        to_approve = get_transactions_to_approve(depth, options["reference"])

        attached = attach_to_tangle(to_approve["trunk_transaction"], to_approve["branch_transaction"], min_weight_magnitude, trytes)

        # TODO: Test on sandbox
        stored_attached = store_and_broadcast(attached)

        final_txs = Array(String).new

        stored_attached.each do |trytes|
          final_txs << @utils.transaction_object(trytes)
        end
        final_txs
      end

      def send_transfer(seed, depth, min_weight_magnitude, transfers, options)
        if !@validator.is_value?(depth)
          return send_data(false, "Invalid depth")
        end

        if !@validator.is_value(min_weight_magnitude)
          return send_data(false, "Invalid min_weight_magnitude")
        end

        trytes = prepare_transfers(seed, transfers, options)
        send_trytes(trytes, depth, min_weight_magnitude, options) unless trytes
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
        if !@validator.is_trytes?(seed)
          return send_data(false, "Invalid Trytes")
        end

        index = 0
        if options["index"]
          index = options["index"].to_i64

          if !@validator.is_value?(index) || index < 0
            return send_data(false, "Invalid Index")
          end
        end

        checksum = options["checksum"] || false
        total = options["total"] || nil

        security = 2

        if options["secuity"]
          security = options["security"]

          if !@validator.is_value?(security) || security < 1 || security > 3
            return send_data(false, "Invalid Security")
          end
        end

        all_addresses = []

        if total
          (0...total).step(1) do |i|
            address = new_address(seed, index, security, checksum)
            all_addresses.push(address)
          end
        else
          new_address = new_address(seed, index, security, checksum)

          if options["return_all"]
            all_addresses.push(new_address)
          end

          index += 1

          is_used = were_addresses_spent_from(new_address)

          find_transactions({"addresses": [new_address]})


        end
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
