require "gameoverseer"

require_relative "server/services/game"

class Network
  class Server
    def initialize(host, port, &block)
      @host, @port, @block = host, port, block
      @server = nil
    end

    def start
      Thread.start { @server = GameOverseer.activate(@host, @port) }
    end

    def stop
      @server.deactivate
    end
  end
end