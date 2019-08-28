class Network
  Data = Struct.new(:socket, :client_sequence_id, :server_sequence_id, :read_queue, :write_queue)

  Packet = Struct.new(:sequence_id, :reliable, :type, :message, :retries, :retry_attempted_at, :retry_after)
  PACKET_MAX_RETRIES = 5
  PACKET_RESEND_DELAY = 25 # ms
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

  def self.time
    Process.clock_gettime(Process::CLOCK_MONOTONIC) * 1000.0
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

    packet = Packet.new(sequence_id, reliable, type, message, 0, time, 0)
  end

  def self.handle_read(client, network_object)
    packet = Network.packet_from_socket(client.socket.gets)
    return unless packet

    # puts "#{client.send(network_object.is_a?(Server) ? :client_sequence_id : :server_sequence_id)} vs. #{packet.sequence_id} -> #{network_object.class}"
    if true#client.send(network_object.is_a?(Server) ? :client_sequence_id : :server_sequence_id) >= packet.sequence_id
      client.read_queue << packet


      if packet.reliable
        if :acknowledge == packet.type
          _packet = client.write_queue.detect { |pkt| pkt.sequence_id == Integer(packet.message) }
          if _packet
            puts "Got ACK for #{_packet.sequence_id} (↓ #{network_object.class})"
            client.write_queue.delete(_packet)
          end

        else
          pp "Sending ACK for #{packet.sequence_id} (↑ #{network_object.class})"
          network_object.transmit(client, :acknowledge, true, packet.sequence_id)
        end
      end
    else
      puts "rejected: #{packet} (-> #{network_object.class})"
    end
  end

  def self.handle_write(client, network_object)
    client.write_queue.each do |packet|

      if packet.reliable
        if can_send_packet?(packet)
          send_packet(client, packet)

          packet.retries += 1
          packet.retry_attempted_at = Network.time
          packet.retry_after += Network::PACKET_RESEND_DELAY # Increases time between attempts for each attempt
        else
          puts "Failed to send packet: #{packet} (| #{network_object.class})" if packet.retries > Network::PACKET_MAX_RETRIES
          client.write_queue.delete(packet) if packet.retries > Network::PACKET_MAX_RETRIES
        end

      else
        send_packet(client, packet)
        client.write_queue.delete(packet)
      end
    end
  end

  def self.send_packet(client, packet)
    # "(int) sequence_id:(boolean) reliable:(int) type|(string) message"
    client.socket.puts("#{packet.sequence_id}:#{packet.reliable ? 1 : 0}:#{Network::PacketTypeNames.dig(packet.type)}|#{packet.message}")
  end

  def self.can_send_packet?(packet)
    packet.retries <= Network::PACKET_MAX_RETRIES &&
    Network.time >= packet.retry_attempted_at + packet.retry_after
  end
end