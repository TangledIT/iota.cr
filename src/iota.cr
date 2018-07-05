require "./iota/version"
require "./iota/crypto/*"
require "./iota/crypto/helpers/*"
require "./iota/utils/*"
require "./iota/api/helpers/batched_send"
require "./iota/api/commands"
require "./iota/api/wrappers"
require "./iota/api/api"

module IOTA
  class Client
    getter :version, :host, :port, :provider, :sandbox, :token, :make_request, :api, :utils, :validator, :multisig

    @provider : String?
    @valid : IOTA::Utils::InputValidator?

    def initialize(settings = {} of Symbol => String)
      set_settings(settings)
      @utils = IOTA::Utils::Utils.new
      @valid = @utils.validator
      @make_request = IOTA::Utils::MakeRequest.new(@provider, @token)
      @api = IOTA::API::Api.new(@make_request, @sandbox)

      # @multisig = IOTA::Multisig::Multisig.new(self)
    end

    private def set_settings(settings)
      @host = settings[:host]? ? settings[:host] : "http://localhost"
      @port = settings[:port]? ? settings[:port].to_i : 14265
      @provider = settings[:provider]? || @host.to_s.gsub(/\/$/, "") + ":" + @port.to_s
      @sandbox = settings[:sandbox]? || ""
      @token = settings[:token]? || ""

      if @sandbox
        @sandbox = @provider.to_s.gsub(/\/$/, "")
        @provider = @sandbox.to_s + "/commands"
      end
    end
  end
end
