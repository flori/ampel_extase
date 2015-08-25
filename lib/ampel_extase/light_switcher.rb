require 'socket_switcher'

module AmpelExtase
  class LightSwitcher
    def self.for(serial:)
      if serial
        new SocketSwitcher::Port.new(serial)
      else
        Tins::NULL
      end
    end

    def initialize(port)
      @port = port
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
        :aux,
      ].map { |color| __send__(color) }.each(&block)
    end
  end
end
