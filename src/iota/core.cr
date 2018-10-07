# TODO: Write documentation for `Iota`
require "./types"
require "./http_client"
require "./core/*"

module Iota
  class Core
    include HttpClient
    include Types
    include Api

    def initialize(init_settings = {} of Symbol => String)
      configure do |config|
        config.provider = init_settings[:provider]
      end
    end

    def configure
      yield(settings)
    end

    def settings
      @@settings ||= Settings.new
    end
  end
end
