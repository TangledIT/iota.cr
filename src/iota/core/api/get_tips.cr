module Iota
  class Core
    module Api
      module GetTips
        def get_tips
          response = HttpClient.send_command(settings.provider, settings.api_version, {
            command: IRICommand::GET_TIPS,
          })

          if response.status_code == 200
            {data: Responses::GetTips.from_json(response.body), response: response}
          else
            {data: Responses::ErrorResponse.from_json(response.body), response: response}
          end
        end
      end
    end
  end
end
