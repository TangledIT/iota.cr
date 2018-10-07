module Iota
  class Core
    module Api
      module GetNodeInfo
        def get_node_info
          HttpClient.send_command(settings.provider, settings.api_version, {
            command: IRICommand::GET_NODE_INFO
          })
        end
      end
    end
  end
end