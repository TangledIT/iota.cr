module IOTA
  module API
    class Api
      include Wrappers

      def initialize(make_request = IOTA::Utils::MakeRequest::Class, sandbox = String.new)
        @make_request = make_request || IOTA::Utils::MakeRequest.new
        @sandbox = sandbox || ""
        @commands = Commands.new
        @utils = IOTA::Utils::Utils.new
        @validator = @utils.validator || IOTA::Utils::InputValidator.new
      end

      def send_command(command)
        commands_to_batch = ["findTransactions", "getBalances",
                             "getInclusionStates", "getTrytes"]
        command_keys = ["addresses", "bundles", "hashes", "tags",
                        "transactions", "approvees"]

        # TODO: Write batched sends

        @make_request.send(command)
      end

      def attach_to_tangle(trunk_transaction, branch_transaction, min_weight_magnitude, trytes)
        if !@validator.is_hash?(trunk_transaction)
          return send_data(false, "You have provided an invalid hash as a trunk: #{trunk_transaction}")
        end

        if !@validator.is_hash?(branch_transaction)
          return send_data(false, "You have provided an invalid hash as a branch: #{branchTransaction}")
        end

        if !@validator.is_value?(min_weight_magnitude)
          return send_data(false, "Invalid inputs provided")
        end

        if !@validator.is_array_of_trytes(trytes)
          return send_data(false, "Invalid Trytes provided")
        end

        command = @commands.attach_to_tangle(trunk_transaction, branch_transaction, min_weight_magnitude, trytes)
        send_command(command)
      end

      def find_transactions(search_values)
        if !@validator.is_object?(search_values)
          return send_data(false, "You have provided an invalid key value")
        end

        search_keys = search_values.keys
        valid_keys = ["bundles", "addresses", "tags", "approvees"]

        error = false

        search_keys.each do |key|
          if !valid_keys.includes?(key.to_s)
            error = "You have provided an invalid key value"
            break
          end

          hashes = search_values[key]

          if key.to_s == "addresses"
            checked_hashes = Array(String).new
            hashes.each do |address|
              checked_hashes << @utils.no_checksum(address).to_s
            end
            search_values.merge!({"addresses" => checked_hashes})
          end

          # If tags, append to 27 trytes
          if key.to_s == "tags"
            checked_hashes = Array(String).new
            hashes.each do |hash|
              # Simple padding to 27 trytes
              while hash.size < 27
                hash += "9"
              end
              # validate hash
              if !@validator.is_trytes?(hash, 27)
                error = "Invalid Trytes provided"
                break
              end

              checked_hashes << hash.to_s
            end

            search_values.merge!({"tags" => checked_hashes})
          else
            # Check if correct array of hashes
            if !@validator.is_array_of_hashes?(hashes)
              error = "Invalid Trytes provided"
              break
            end
          end
        end

        if error
          return send_data(false, error)
        else
          send_command(@commands.find_transactions(search_values))
        end
      end

      def get_balances(addresses, threshold)
        if !@validator.is_array_of_hashes?(addresses)
          return send_data(false, "Invalid Trytes provided")
        end

        command = @commands.get_balances(addresses.map { |address| @utils.no_checksum(address) }, threshold)
        send_command(command)
      end

      def get_inclusion_states(transactions, tips)
        if !@validator.is_array_of_hashes?(transactions)
          return send_data(false, "Invalid Trytes provided")
        end

        if !@validator.is_array_of_hashes?(tips)
          return send_data(false, "Invalid Trytes provided")
        end
        send_command(@commands.get_inclusion_states(transactions, tips))
      end

      def get_node_info
        send_command(@commands.get_node_info)
      end

      def get_neighbors
        send_command(@commands.get_neighbors)
      end

      def add_neighbors(uris)
        (0...uris.size).step(1) do |i|
          return send_data(false, "You have provided an invalid URI for your Neighbor: " + uris[i]) if !@validator.is_uri?(uris[i])
        end
        send_command(@commands.add_neighbors(uris))
      end

      def remove_neighbors(uris)
        (0...uris.size).step(1) do |i|
          return send_data(false, "You have provided an invalid URI for your Neighbor: " + uris[i]) if !@validator.is_uri?(uris[i])
        end
        send_command(@commands.remove_neighbors(uris))
      end

      def get_tips
        send_command(@commands.get_tips)
      end

      def get_transactions_to_approve(depth, reference = nil)
        if !@validator.is_value?(depth)
          return send_data(false, "Invalid inputs provided")
        end
        send_command(@commands.get_transactions_to_approve(depth, reference))
      end

      def get_trytes(hashes)
        if !@validator.is_array_of_hashes?(hashes)
          return send_data(false, "Invalid Trytes provided")
        end
        send_command(@commands.get_trytes(hashes))
      end

      def interrupt_attaching_to_tangle
        send_command(@commands.interrupt_attaching_to_tangle)
      end

      def broadcast_transactions(trytes)
        if !@validator.is_array_of_attached_trytes(trytes)
          return send_data(false, "Invalid attached Trytes provided")
        end
        send_command(@commands.broadcast_transactions(trytes))
      end

      def store_transactions(trytes)
        if !@validator.is_array_of_attached_trytes(trytes)
          return send_data(false, "Invalid attached Trytes provided")
        end
        send_command(@commands.store_transactions(trytes))
      end

      def check_consistency(tails)
        if !@validator.is_array_of_hashes(tails)
          return send_data(false, "Invalid tails provided")
        end
        send_command(@commands.check_consistency(tails))
      end

      private def send_data(status, data)
        {status, data}
      end
    end
  end
end
