class Network
  class Client

    attr_reader :sequence_id
    def initialize(remote_host, port)
      @socket = TCPSocket.new(remote_host, port)
      @client = Data.new(@socket, 0, [], [])
      @sequence_id = 0


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
      Network.handle_read(@client, self)
    end

    def handle_write
      Network.handle_write(@client)
    end

    def transmit(client, type, reliable, message)
      packet = Network.create_packet(@sequence_id, reliable, type, message)

      @sequence_id += 1
      @client.write_queue << packet
    end
  end
end