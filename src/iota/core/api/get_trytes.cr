module Iota
  class Core
    module Api
      module GetTrytes
        def get_trytes(hashes : Array(String))
          response = HttpClient.send_command(settings.provider, settings.api_version, {
            command: IRICommand::GET_TRYTES, hashes: hashes,
          })

          if response.status_code == 200
            {data: Responses::GetTrytes.from_json(response.body), response: response}
          else
            {data: Responses::ErrorResponse.from_json(response.body), response: response}
          end
        end
      end
    end
  end
end
