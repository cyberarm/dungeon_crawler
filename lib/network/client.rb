class Network
  class Client

    def initialize(remote_host, port)
      @socket = TCPSocket.new(remote_host, port)
      @server = Data.new(@socket, 0, 0, [], [])

      @connected = true
    end

    def run
      transmit(nil, :request_connect, true, "")

      Thread.start do
        while(@connected)
          handle_read
        end
      end

      Thread.start do
        while(@connected)
          handle_write

          sleep 0.05
        end

        @socket.close
      end
    end

    def handle_read
      # p :client
      Network.handle_read(@server, self)

      @server.read_queue.each do |packet|
        if packet.sequence_id == @server.server_sequence_id
          @server.server_sequence_id += 1
          @server.read_queue.delete(packet)

          puts "accepted packet: #{packet} (-> #{self.class})"
          process_packet(packet)
        end
      end
    end

    def process_packet(packet)
      # TODO: Client stuff :D
    end

    def handle_write
      Network.handle_write(@server)
    end

    def transmit(client, type, reliable, message)
      packet = Network.create_packet(@server.client_sequence_id, reliable, type, message)

      @server.client_sequence_id += 1
      @server.write_queue << packet
    end
  end
end