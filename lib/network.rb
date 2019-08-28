class Network
  Data = Struct.new(:socket, :client_sequence_id, :server_sequence_id, :read_queue, :write_queue)

  Packet = Struct.new(:sequence_id, :reliable, :type, :message)
  PacketTypes = {
    0 => :acknowledge, # id:0|packet_sequence_id

    1  => :request_connect, # id:1|
    2  => :accept_connect,
    3  => :reject_connect,

    4  => :request_map,
    5  => :receive_map,

    6  => :refused,
    7  => :disconnect,
    8  => :heartbeat,

    9  => :entity_create, # id:4|message
    10 => :entity_update,
    11 => :entity_destroy,
  }

  PacketTypeNames = {}

  PacketTypes.each do |type, name|
    PacketTypeNames[name] = type
  end

  def self.packet_from_socket(string)
    return nil unless string

    packet = Packet.new
    parts = string.chomp.split("|")
    header = parts.first.split(":")

    packet.sequence_id = Integer(header.first)
    packet.reliable    = Integer(header[1]) == 1
    packet.type        = Network::PacketTypes.dig( Integer(header.last) )

    packet.message = parts.size == 1 ? "" : parts.last

    return packet
  end

  def self.create_packet(sequence_id, reliable, type, message)
    raise TypeError, "Unknown packet type: #{type}" unless Network::PacketTypeNames.dig(type)
    _sequence_id = sequence_id
    _reliable = reliable ? 1 : 0

    packet = Packet.new(_sequence_id, _reliable, Network::PacketTypeNames.dig(type), message)
  end

  def self.handle_read(client, network_object)
    packet = Network.packet_from_socket(client.socket.gets)
    return unless packet

    # puts "#{client.send(network_object.is_a?(Server) ? :client_sequence_id : :server_sequence_id)} vs. #{packet.sequence_id} -> #{network_object.class}"
    if client.send(network_object.is_a?(Server) ? :client_sequence_id : :server_sequence_id) >= packet.sequence_id
      client.read_queue << packet


      if packet.reliable
        if :acknowledge == packet.type
          _packet = client.write_queue.detect { |pkt| pkt.sequence_id == Integer(packet.message) }
          if _packet
            puts "Got ACK for #{_packet.sequence_id}"
            client.write_queue.delete(_packet)
          end

        else
          pp "Sending ACK for #{packet.sequence_id}"
          network_object.transmit(client, :acknowledge, true, packet.sequence_id)
        end
      end
    else
      puts "rejected: #{packet} (-> #{network_object.class})"
    end
  end

  def self.handle_write(client)
    client.write_queue.each do |packet|
      # "(int) sequence_id:(boolean) reliable:(int) type|(string) message"
      client.socket.puts("#{packet.sequence_id}:#{packet.reliable}:#{packet.type}|#{packet.message}")

      reliable = packet.reliable == 1
      client.write_queue.delete(packet) unless reliable
    end
  end
end