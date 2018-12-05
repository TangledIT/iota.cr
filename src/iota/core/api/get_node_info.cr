module Iota
  class Core
    module Api
      module GetNodeInfo
        def get_node_info
          response = HttpClient.send_command(settings.provider, settings.api_version, {
            command: IRICommand::GET_NODE_INFO,
          })
          {data: Responses::GetNodeInfo.from_json(response.body), response: response}
        end
      end
    end
  end
end
