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
    end
  end
end
