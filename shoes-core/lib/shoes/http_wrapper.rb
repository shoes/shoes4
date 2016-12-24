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
    def self.read_chunks(url, meth, body, headers = {}, started_proc = nil, redirects_left = 5, &blk)
      uri = URI.parse(url)
      Net::HTTP.start(uri.host, uri.port, use_ssl: is_ssl?(uri)) do |http|
        request = build_request(uri, meth, body, headers)

        http.request(request) do |response|
          case response
          when Net::HTTPSuccess
            handle_success(response, started_proc, &blk)
          when Net::HTTPRedirection
            handle_redirect(response, headers, started_proc, redirects_left, &blk)
          else
            handle_error(response)
          end
        end
      end
    end

    private

    def self.build_request(uri, meth, body, headers)
      klass = Net::HTTP.const_get(meth.downcase.capitalize)
      klass.new(uri).tap do |request|
        request.body = body
        headers.each do |(key, value)|
          request[key] = value
        end
      end
    end

    def self.handle_redirect(response, headers, started_proc, redirects_left, &blk)
      raise "Exhausted trying to redirect... See ya'" if redirects_left <= 0

      next_uri = URI.parse(response["Location"])

      if schemes_mismatch?(response.uri, next_uri) &&
          !allowed_scheme_change?(response.uri, next_uri)
        raise "Disallowed redirection from '#{response.uri.scheme}' to '#{next_uri.scheme}'"
      end

      read_chunks(next_uri.to_s, "GET", nil, headers, started_proc, redirects_left - 1, &blk)
    end

    def self.schemes_mismatch?(original_uri, new_uri)
      original_uri.scheme != new_uri.scheme
    end

    def self.allowed_scheme_change?(original_uri, new_uri)
      original_uri.scheme == "http" && new_uri.scheme == "https"
    end

    def self.handle_success(response, started_proc)
      started_proc.call(response) if started_proc
      response.read_body do |chunk|
        yield response, chunk
      end
    end

    def self.handle_error(response)
      raise "#{response.code} #{response.message}"
    end

    def self.is_ssl?(uri)
      uri.scheme == "https"
    end
  end
end
