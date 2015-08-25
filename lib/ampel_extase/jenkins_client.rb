require 'open-uri'
require 'tins/xt'
require 'json'
require 'uri'

module AmpelExtase
  class JenkinsClient
    def initialize(url)
      url = URI.parse(url.to_s) unless URI::HTTP === url
      @url = url
    end

    attr_reader :url

    def api_url(*path)
      [ @url, *path, 'api', 'json' ].compact * '/'
    end

    def fetch(url = api_url)
      puts "Fetching #{url.to_s.inspect}."
      JSON open(url).read
    rescue => e
      e.message << " for #{url.inspect}"
      raise
    end

    def fetch_build(type)
      url = if sym = type.ask_and_send(:to_sym)
              key = sym.to_s.camelize(:lower)
              key[0, 1] = key[0, 1].downcase
              api_url(key)
            else
              api_url(type)
            end
      fetch url
    end
  end
end
