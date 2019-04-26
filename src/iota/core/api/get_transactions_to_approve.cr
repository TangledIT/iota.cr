module Iota
  class Core
    module Api
      module GetTransactionsToApprove
        def get_transactions_to_approve(depth : Int32, reference = "")
          data = {} of Symbol => String | Int32
          data[:command] = IRICOMMAND::GET_TRANSACTIONS_TO_APPROVE
          data[:depth] = depth
          data[:reference] = reference unless reference.empty?

          response = HttpClient.send_command(settings.provider, settings.api_version, data)

          if response.status_code == 200
            {data: Responses::GetTransactionsToApprove.from_json(response.body), response: response}
          else
            {data: Responses::ErrorResponse.from_json(response.body), response: response}
          end
        end
      end
    end
  end
end
