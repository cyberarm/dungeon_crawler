require "socket"

class Network
  class Server
    attr_reader :clients
    def initialize(host = "localhost", port = 56789, max_clients = 16, tick_rate = 16)
      @host = host
      @port = port
      @max_clients = max_clients
      @tick_rate   = tick_rate

      @socket = TCPServer.new(@host, @port)
      @sequence_id = 0
      @serve  = false

      @clients = []

      @last_tick_time = time
      @tick_interval  = 1000.0 / @tick_rate
    end

    def time
      Process.clock_gettime(Process::CLOCK_MONOTONIC) * 1000.0
    end

    def run(&block)
      @serve = true

      # TODO: Improve timer to sleep for as long as possible
      Thread.start do
        while(@serve)
          simulate(&block)
          sleep 0.01
        end
      end

      while(@serve)
        handle(@socket.accept)
      end

      @socket.close
    end

    def run_in_background(&block)
      Thread.start { run(&block) }
    end

    def simulate(&block)
      if (time - @last_tick_time) >= @tick_interval
        @last_tick_time = time

        block.call(self) if block
      end
    end

    def handle(socket)
      client = Data.new(socket, 0, [], [])
      @clients << client
      Thread.start do
        while(@serve)
          handle_read(client)
        end
      end

      Thread.start do
        while(@serve)
          handle_write(client)

          sleep 0.05
        end
      end
    end

    def handle_read(client)
      # p :server
      Network.handle_read(client, self)
    end

    def handle_write(client)
      Network.handle_write(client)
    end

    def transmit(client, type, reliable, message)
      packet = Network.create_packet(@sequence_id, reliable, type, message)

      @sequence_id += 1
      client.write_queue << packet
    end

    def broadcast(type, reliable, message)
      @clients.each do |client|
        transmit(client, type, reliable, message)
      end
    end

    def stop(mode = :gentle) # :gentle, :hard
      case mode
      when :gentle
        @serve = false
      when :hard
        @serve = false
      else
        @serve = false
      end
    end
  end
end