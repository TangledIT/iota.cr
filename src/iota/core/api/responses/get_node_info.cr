module Iota
  class Core
    module Api
      module Responses
        class GetNodeInfo
          JSON.mapping(
            appName: String,
            appVersion: String,
            jreAvailableProcessors: Int64,
            jreFreeMemory: Int64,
            jreVersion: String,
            jreMaxMemory: Int64,
            jreTotalMemory: Int64,
            latestMilestone: String,
            latestMilestoneIndex: Int64,
            latestSolidSubtangleMilestone: String,
            latestSolidSubtangleMilestoneIndex: Int64,
            milestoneStartIndex: Int64,
            neighbors: Int64,
            packetsQueueSize: Int64,
            time: Int64,
            tips: Int64,
            transactionsToRequest: Int64,
            duration: Int64
          )

          def time
            Time.unix_ms(@time)
          end
        end
      end
    end
  end
end
