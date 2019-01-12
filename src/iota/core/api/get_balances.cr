module Iota
  class Core
    module Api
      module GetBalances
        def get_balances(addresses : Array(String), threshold : Int32, tips = [] of String)
          data = {} of Symbol => Array(String) | String | Int32
          data[:command] = IRICommand::GET_BALANCES
          data[:addresses] = addresses
          data[:threshold] = threshold || 100
          data[:tips] = tips unless tips.size == 0

          response = HttpClient.send_command(settings.provider, settings.api_version, data)

          if response.status_code == 200
            {data: Responses::GetBalances.from_json(response.body), response: response}
          else
            {data: Responses::ErrorResponse.from_json(response.body), response: response}
          end
        end
      end
    end
  end
end
