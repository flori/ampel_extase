require 'open-uri'
require 'tins/xt'
require 'json'
require 'uri'

module AmpelExtase
  class SemaphoreClient
    def initialize(url)
      @url = url
    end

    attr_reader :url

    def fetch
      puts "Fetching #{url.inspect}."
      JSON open(url).read
    rescue => e
      e.message << " for #{url.inspect}"
      raise
    end

    def fetch_build(type)
      builds = fetch['builds']
      case type
      when :last_completed_build
        builds.detect { |build| !!build['finished_at'] }
      when :last_build
        builds.first
      end
    end
  end
end
