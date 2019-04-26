module Iota
  class Core
    module Api
      module BroadcastTransactions
        def broadcast_transactions(trytes : Array(String))
          response = HttpClient.send_command(settings.provider, settings.api_version, {
            command: IRICOMMAND::BROADCAST_TRANSACTIONS, trytes: trytes,
          })

          if response.status_code == 200
            {data: Responses::BroadcastTransactions.from_json(response.body), response: response}
          else
            {data: Responses::ErrorResponse.from_json(response.body), response: response}
          end
        end
      end
    end
  end
end
