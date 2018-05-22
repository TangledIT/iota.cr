require "./iota/*"
require "./iota/utils/*"
require "./iota/api/*"

module IOTA
  class Client
    getter :version, :host, :port, :provider, :sandbox, :token, :broker, :api, :utils, :validator, :multisig

    @provider : String?
    @validator : IOTA::Utils::InputValidator?

    def initialize(settings = {} of Symbol => String)
      set_settings(settings)
      @utils = IOTA::Utils::Utils.new
      @validator = @utils.validator
      @broker = IOTA::Utils::Broker.new(@provider, @token, @timeout)
      @api = IOTA::API::Api.new(@broker, @sandbox)

      # @multisig = IOTA::Multisig::Multisig.new(self)
    end

    private def set_settings(settings)
      @host = settings[:host]? ? settings[:host] : "http://localhost"
      @port = settings[:port]? ? settings[:port].to_i : 14265
      @provider = settings[:provider]? || @host.to_s.gsub(/\/$/, "") + ":" + @port.to_s
      @sandbox = settings[:sandbox]? || ""
      @token = settings[:token]? || ""
      @timeout = settings[:timeout]? ? settings[:timeout].to_i : 120

      if @sandbox
        @sandbox = @provider.to_s.gsub(/\/$/, "")
        @provider = @sandbox.to_s + "/commands"
      end
    end
  end
end
