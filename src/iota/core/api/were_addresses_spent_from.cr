module Iota
  class Core
    module Api
      module WereAddressesSpentFrom
        def were_addresses_spent_from(addresses : Array(String))
          response = HttpClient.send_command(settings.provider, settings.api_version, {
            command: IRICommand::WERE_ADDRESSES_SPENT_FROM, addresses: addresses,
          })

          if response.status_code == 200
            {data: Responses::WereAddressesSpentFrom.from_json(response.body), response: response}
          else
            {data: Responses::ErrorResponse.from_json(response.body), response: response}
          end
        end
      end
    end
  end
end
