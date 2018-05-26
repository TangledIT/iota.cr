require "uri"
require "http/client"
require "json"

module IOTA
  module Utils
    class Broker
      def initialize(provider = String.new, token = String.new, timeout = 120)
        @provider = provider || ""
        @token = token || ""
        @timeout = (timeout && timeout.to_i > 0) ? timeout : 0
      end

      def send(command)
        context = OpenSSL::SSL::Context::Client.insecure
        headers = HTTP::Headers{"Content-Type"       => "application/json",
                                "X-IOTA-API-Version" => "1"}
        response = HTTP::Client.post(@provider, headers, command.to_json, tls: context)
        success = true
        begin
          data = JSON.parse(response.body)
          if data["error"]?
            data = data["error"]
            success = false
          else
            data = prepare_response(data, command["command"])
          end
        rescue JSON::ParseException
          success = false
          data = "Invalid response"
        end
        {success, data}
      end

      def prepare_response(result, command)
        result_map = {
          "getNeighbors"       => "neighbors",
          "addNeighbors"       => "addedNeighbors",
          "removeNeighbors"    => "removedNeighbors",
          "getTips"            => "hashes",
          "findTransactions"   => "hashes",
          "getTrytes"          => "trytes",
          "getInclusionStates" => "states",
          "attachToTangle"     => "trytes",
          "checkConsistency"   => "state",
        }

        if result && result_map.key?(command)
          if command === "attachToTangle" && result["id"]?
            result
          else
            result = result[result_map[command]]
          end
        end
        result
      end
    end
  end
end
