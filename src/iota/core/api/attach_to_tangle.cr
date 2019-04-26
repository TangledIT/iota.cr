module Iota
  class Core
    module Api
      module AttachToTangle
        def attach_to_tangle(trunk_transaction : String,
                             branch_transaction : String,
                             min_weight_magnitude : Int32,
                             trytes : Array(String))
          response = HttpClient.send_command(settings.provider, settings.api_version, {
            command: IRICOMMAND::ATTACH_TO_TANGLE,
            trunkTransaction: trunk_transaction, branchTransaction: branch_transaction,
            minWeightMagnitude: min_weight_magnitude, trytes: trytes,
          })

          if response.status_code == 200
            {data: Responses::AttachToTangle.from_json(response.body), response: response}
          else
            {data: Responses::ErrorResponse.from_json(response.body), response: response}
          end
        end
      end
    end
  end
end
