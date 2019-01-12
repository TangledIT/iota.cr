module Iota
  class Core
    module Api
      module FindTransactions
        def find_transactions(addresses = [] of String,
                              tags = [] of String,
                              bundles = [] of String,
                              approvees = [] of String)
          data = {} of Symbol => Array(String) | String
          data[:addresses] = addresses if addresses.size > 0
          data[:tags] = tags if tags.size > 0
          data[:bundles] = bundles if bundles.size > 0
          data[:approvees] = approvees if approvees.size > 0
          data[:command] = IRICommand::FIND_TRANSACTIONS

          response = HttpClient.send_command(settings.provider, settings.api_version, data)

          if response.status_code == 200
            {data: Responses::FindTransactions.from_json(response.body), response: response}
          else
            {data: Responses::ErrorResponse.from_json(response.body), response: response}
          end
        end
      end
    end
  end
end
