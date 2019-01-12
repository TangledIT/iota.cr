module Iota
  class Core
    module Api
      module InterruptAttachingToTangle
        def interrupt_attaching_to_tangle
          response = HttpClient.send_command(settings.provider, settings.api_version, {
            command: IRICommand::INTERRUPT_ATTACHING_TO_TANGLE,
          })

          if response.status_code == 200
            {data: Responses::InterruptAttachingToTangle.from_json(response.body), response: response}
          else
            {data: Responses::ErrorResponse.from_json(response.body), response: response}
          end
        end
      end
    end
  end
end
