module Iota
  class Core
    module Api
      module RemoveNeighbors
        def remove_neighbors(uris : Array(String))
          response = HttpClient.send_command(settings.provider, settings.api_version, {
            command: IRICOMMAND::REMOVE_NEIGHBORS, uris: uris,
          })

          if response.status_code == 200
            {data: Responses::RemoveNeighbors.from_json(response.body), response: response}
          else
            {data: Responses::ErrorResponse.from_json(response.body), response: response}
          end
        end
      end
    end
  end
end
