require 'open-uri'
require 'tins/xt'
require 'json'
require 'uri'

module AmpelExtase
  class JenkinsClient
    def initialize(url, debug: false)
      url = URI.parse(url.to_s) unless URI::HTTP === url
      @url, @debug = url, debug
    end

    def api_url(*path)
      [ @url, *path, 'api', 'json' ].compact * '/'
    end

    def console_url(number)
      [ @url, number, 'consoleText' ] * '/'
    end

    def fetch(url = api_url)
      @debug and STDERR.puts "Fetching #{url.to_s.inspect}."
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

    def fetch_build_revision(type)
      data = fetch_build(type)
      data['actions'].find { |x| x.keys.include?('lastBuiltRevision') }['lastBuiltRevision']['SHA1']
    rescue
      nil
    end

    def fetch_console_text(type)
      build = fetch_build(type)
      open(console_url(build['number'])).read
    end
  end
end
