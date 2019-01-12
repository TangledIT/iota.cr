module Iota
  class Core
    module Api
      module StoreTransactions
        def store_transactions(trytes : Array(String))
          response = HttpClient.send_command(settings.provider, settings.api_version, {
            command: IRICommand::STORE_TRANSACTIONS, trytes: trytes,
          })

          if response.status_code == 200
            {data: Responses::StoreTransactions.from_json(response.body), response: response}
          else
            {data: Responses::ErrorResponse.from_json(response.body), response: response}
          end
        end
      end
    end
  end
end
