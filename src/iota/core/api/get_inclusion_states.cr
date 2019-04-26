module Iota
  class Core
    module Api
      module GetInclusionStates
        def get_inclusion_states(transactions : Array(String), tips : Array(String))
          response = HttpClient.send_command(settings.provider, settings.api_version, {
            command: IRICOMMAND::GET_INCLUSION_STATES, transactions: transactions, tips: tips,
          })

          if response.status_code == 200
            {data: Responses::GetInclusionStates.from_json(response.body), response: response}
          else
            {data: Responses::ErrorResponse.from_json(response.body), response: response}
          end
        end
      end
    end
  end
end
