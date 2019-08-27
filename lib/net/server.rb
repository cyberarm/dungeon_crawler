require "socket"

class Network
  Packet = Struct.new(:sequence_id, :type, :message, :reliable)

  class Server
    Client = Struct.new(:socket, :sequence_id, :read_queue, :write_queue)

    def initialize(host = "localhost", port = 56789, max_clients = 16, tick_rate = 16)
      @host = host
      @port = port
      @max_clients = max_clients
      @tick_rate   = tick_rate
      
      @socket = TCPServer.new(@host, @port)
      @serve  = false
    end

    def run
      while(@serve)
        handle(@socket.accept)
      end

      @socket.close
    end

    def handle(socket)
      client = Client.new(socket, 0)
      Thread.start do
        while(@serve)
          handle_read(client)
        end
      end

      Thread.start do
        while(@serve)
          handle_write(client)
        end
      end
    end

    def handle_read(client)
      message = client.socket.gets
      parts = message.chomp.split("|")
      header = parts.first.split(":")
      
      sequence_id = Integer(header.first)
      type = Integer(header.last)
      message = parts.last
    end
    
    def handle_write(client)
      client.write_queue.each do |packet|
        client.socket.puts("#{packet.sequence_id}:#{packet.type}|#{packet.message}")
        
        client.write_queue.delete(packet) unless packet.reliable
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

server = Network::Server.new
server.run
