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

      def send_command(command, &callback)
        @broker.send(command, &callback)
      end

      def get_node_info(&callback)
        send_command(@commands.get_node_info, &callback)
      end
    end
  end
end
