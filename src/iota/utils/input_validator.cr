module IOTA
  module Utils
    class InputValidator
      def is_all_nine?(input)
        /^[9]+$/.match?(input)
      end

      def is_value?(input)
        input && input.is_a?(Integer)
      end

      def is_num?(input)
        /^(\d+\.?\d{0,15}|\.\d{0,15})$/.match(input.to_s)
      end

      def is_string?(input)
        input.is_a?(String)
      end

      def is_array?(input)
        input.is_a?(Array)
      end

      def is_object?(input)
        input.is_a?(Hash)
      end

      def is_hash?(input)
        isTrytes(input, 81)
      end

      def is_address?(input)
        if input.size == 90
          if !is_trytes(input, 90)
            return false
          end
        else
          if !is_trytes(input, 81)
            return false
          end
        end
        true
      end

      def is_trytes?(input, length = "0,")
        is_string?(input) && /^[9A-Z]{#{length}}$/.match(input.to_s)
      end

      def isArrayOfTrytes(trytesArray)
        return false if !isArray(trytesArray)

        trytesArray.each do |tryte|
          return false if !isTrytes(tryte, 2673)
        end
        true
      end

      def is_array_of_hashes?(input)
        return false if !is_array?(input)

        input.each do |entry|
          return false if !is_address?(entry)
        end
        true
      end

      def is_array_of_attachedTrytes?(trytes)
        return false if !is_array(trytes)

        (0...trytes.size).step(1) do |i|
          tryte = trytes[i]
          return false if !is_trytes?(tryte, 2673)

          last_trytes = tryte.slice(2673 - (3 * 81), trytes.size)
          return false if is_all_nine?(last_trytes)
        end
        true
      end

      def is_array_of_tx_objects?(bundle)
        bundle = bundle.transactions if bundle.class == IOTA::Models::Bundle

        return false if !is_array?(bundle) || bundle.length == 0

        bundle.each do |tx_object|
          if tx_object.class != IOTA::Models::Transaction
            tx_object = IOTA::Models::Transaction.new(tx_object)
          end
          return false if !tx_object.valid?
        end
        true
      end

      def is_transfers_array?(transfers_array)
        return false if !is_array?(transfers_array)

        transfers_array.each do |transfer|
          if transfer.class != IOTA::Models::Transfer
            transfer = IOTA::Models::Transfer.new(transfer)
          end
          return false if !transfer.valid?
        end
        true
      end

      def is_inputs?(inputs)
        return false if !is_array?(inputs)

        inputs.each do |input|
          if input.class != IOTA::Models::Input
            input = IOTA::Models::Input.new(input)
          end
          return false if !input.valid?
        end
        true
      end

      # Checks that a given uri is valid
      # Valid Examples:
      # udp://[2001:db8:a0b:12f0::1]:14265
      # udp://[2001:db8:a0b:12f0::1]
      # udp://8.8.8.8:14265
      # udp://domain.com
      # udp://domain2.com:14265
      def is_uri?(node)
        get_inside = /^(udp|tcp):\/\/([\[][^\]\.]*[\]]|[^\[\]:]*)[:]{0,1}([0-9]{1,}$|$)/i

        strip_brackets = /[\[]{0,1}([^\[\]]*)[\]]{0,1}/

        uri_test = /((^\s*((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))\s*$)|(^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$))|(^\s*((?=.{1,255}$)(?=.*[A-Za-z].*)[0-9A-Za-z](?:(?:[0-9A-Za-z]|\b-){0,61}[0-9A-Za-z])?(?:\.[0-9A-Za-z](?:(?:[0-9A-Za-z]|\b-){0,61}[0-9A-Za-z])?)*)\s*$)/

        match = get_inside.match(node)
        return false if match.nil? || match[2].nil?

        uri_test.match?(strip_brackets.match(match[2])[1])
      end
    end
  end
end
