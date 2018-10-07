require "uri"
require "http/client"
require "json"

module Iota
  module HttpClient
    class RequestError < Exception; end

    def self.send_command(provider : String, api_version : Int64, command = {} of Symbol => String)
      context = OpenSSL::SSL::Context::Client.insecure
      headers = HTTP::Headers{"Content-Type"       => "application/json",
                              "X-IOTA-API-Version" => api_version.to_s}
      response = HTTP::Client.post(provider, headers, command.to_json, tls: context)
      success = true
      begin
        data = JSON.parse(response.body)
        if data["error"]?
          RequestError.new(data["error"].to_s)
        else
          return data
        end
      rescue JSON::ParseException
        raise RequestError.new(response.body)
      end
    end
  end
end