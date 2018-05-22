module IOTA
  module API
    class Api
      # include Wrappers

      def initialize(broker = IOTA::Utils::Broker::Class, sandbox = String.new)
        @broker = broker || IOTA::Utils::Broker.new
        @sandbox = sandbox || ""
        @commands = Commands.new
        @utils = IOTA::Utils::Utils.new
        @validator = @utils.validator || IOTA::Utils::InputValidator.new
      end

      def send_command(command)
        @broker.send(command)
      end

      def get_node_info
        send_command(@commands.get_node_info)
      end

      def get_neighbors
        send_command(@commands.get_neighbors)
      end

      def get_tips
        send_command(@commands.get_tips)
      end

      def interrupt_attaching_to_tangle
        send_command(@commands.interrupt_attaching_to_tangle)
      end

      def attach_to_tangle(trunk_transaction, branch_transaction, min_weight_magnitude, trytes)
        # Check if correct trunk
        if !@validator.is_hash?(trunk_transaction)
          return send_data(false, "You have provided an invalid hash as a trunk: #{trunk_transaction}")
        end

        # Check if correct branch
        if !@validator.is_hash?(branch_transaction)
          return send_data(false, "You have provided an invalid hash as a branch: #{branchTransaction}")
        end

        # Check if minweight is integer
        if !@validator.is_value?(min_weight_magnitude)
          return send_data(false, "Invalid inputs provided")
        end

        # Check if array of trytes
        if !@validator.is_array_of_trytes(trytes)
          return send_data(false, "Invalid Trytes provided")
        end

        command = @commands.attach_to_tangle(trunk_transaction, branch_transaction, min_weight_magnitude, trytes)
        send_command(command)
      end
    end
  end
end
