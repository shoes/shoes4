# frozen_string_literal: true

require 'uri'
require 'net/http'

# Wrapper for Net::HTTP to provide us to the functionality that we need which
# isn't easily available from any particular gem out there :(
#
# Specific things this class does that we need include:
#
#   1) Reading in chunks to trigger progress
#   2) Allow for graceful redirection
#
# Most of the gems out there do 2) but not 1), or do both but are untested on
# JRuby.
#
class Shoes
  class HttpWrapper
    def execute(url, meth, body, headers = {}, redirects_left = 5, &blk)
      uri = URI(url)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
        request = build_request(uri, meth, body, headers)

        http.request(request) do |response|
          case response
          when Net::HTTPRedirection
            ensure_can_redirect(response, redirects_left)
            next_location = URI(response["Location"])
            execute(next_location, "GET", nil, headers, redirects_left - 1, &blk)
          when Net::HTTPSuccess
            response.read_body do |chunk|
              yield response, chunk
            end
          else
            raise "#{response.code} #{response.message}"
          end
        end
      end
    end

    def build_request(uri, meth, body, headers)
      klass = Net::HTTP.const_get(meth.downcase.capitalize)
      klass.new(uri).tap do |request|
        request.body = body
        headers.each do |(key, value)|
          request[key] = value
        end
      end
    end

    def ensure_can_redirect(_response, redirects_left)
      # TODO: Detect and reject scheme changes except http -> https

      raise "Exhausted trying to redirect... See ya'" if redirects_left <= 0
    end
  end
end
