module IOTA
  module Utils
    class Utils
      include Ascii

      getter :validator

      def initialize
        @validator = InputValidator.new
      end

      def no_checksum(address)
        is_single_address = @validator.is_string?(address)

        return address if is_single_address && address.size == 81

        # If only single address, turn it into an array
        if is_single_address
          addresses = [address]
        else
          addresses = address
        end

        addresses_with_checksum = Array(String).new
        (0...addresses.size).step(1) do |i|
          addr = addresses[i].to_s
          checksum_addr = addr.match(/^(.{0,81}[^\s\S]*)/).try &.[0]
          addresses_with_checksum << checksum_addr if checksum_addr
        end

        # return either string or the list
        if is_single_address
          return addresses_with_checksum.first
        else
          return addresses_with_checksum
        end
      end
    end
  end
end
