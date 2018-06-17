require "uri"
require "http/client"
require "json"

module IOTA
  module Utils
    class MakeRequest
      property :provider

      def initialize(provider = String.new, token = String.new)
        @provider = provider || "http://localhost:14265"
        @token = token || ""
      end

      def set_provider(provider = String.new)
        @provider = provider || "http://localhost:14265"
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
            data = prepare_result(data, command["command"])
          end
        rescue JSON::ParseException
          success = false
          data = "Invalid response"
        end
        {success, data}
      end

      # TODO : Write
      def batched_send(command, keys, batch_size)
        request_stack = Array(String).new

        keys.each do |key|
          puts command[key]
          #clone = command[key].slice
          #puts slice

        end
        { true, { } of String => String }
      end

      # TODO : Write
      def sandbox_send(job)
      end

      def prepare_result(result, command)
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

        if result && result_map.has_key?(command)
          if command == "attachToTangle" && result["id"]?
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
