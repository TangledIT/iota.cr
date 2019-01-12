module Iota
  class Core
    module Api
      module GetNeighbors
        def get_neighbors
          response = HttpClient.send_command(settings.provider, settings.api_version, {
            command: IRICommand::GET_NEIGHBORS,
          })

          if response.status_code == 200
            {data: Responses::GetNeighbors.from_json(response.body), response: response}
          else
            {data: Responses::ErrorResponse.from_json(response.body), response: response}
          end
        end
      end
    end
  end
end
