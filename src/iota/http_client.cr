require "uri"
require "http/client"
require "json"

module Iota
  module HttpClient
    class RequestError < Exception; end

    def self.send_command(provider : String, api_version : Int64, data = Hash(K, V))
      context = OpenSSL::SSL::Context::Client.insecure
      headers = HTTP::Headers{"Content-Type"       => "application/json",
                              "X-IOTA-API-Version" => api_version.to_s}
      p data.to_json
      HTTP::Client.post(provider, headers, data.to_json, tls: context)
    end
  end
end
