module Iota
  class Core
    module Api
      module GetNodeInfo
        def get_node_info
          response = HttpClient.send_command(settings.provider, settings.api_version, {
            command: IRICOMMAND::GET_NODE_INFO,
          })
          if response.status_code == 200
            {data: Responses::GetNodeInfo.from_json(response.body), response: response}
          else
            {data: Responses::ErrorResponse.from_json(response.body), response: response}
          end
        end
      end
    end
  end
end
