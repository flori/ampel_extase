require 'socket_switcher'

module AmpelExtase
  class LightSwitcher
    def initialize(serial, debug: false)
      @port = SocketSwitcher::Port.new(serial, debug: debug)
    end

    attr_reader :port

    def green
      @port.device(0)
    end

    def red
      @port.device(1)
    end

    def aux
      @port.device(2)
    end

    def each(&block)
      [
        :green,
        :red,
        # not in use for now :aux,
      ].map { |color| __send__(color) }.each(&block)
    end
  end
end

