module IOTA
  module Utils
    class Utils
      include Ascii

      getter :validator

      def initialize
        @validator = InputValidator.new
      end
    end
  end
end
