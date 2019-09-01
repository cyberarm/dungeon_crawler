class Network
  class Server
    class GameService < GameOverseer::Service
      def setup
        channel_manager.register_channel("game", self)
        set_safe_methods([:entity, :join, :leave])
      end

      def process(data)
        pp data

        data_to_method(data)
      end

      def pack_vector(vector)
        "#{vector.x}:#{vector.y}:#{vector.z}:#{vector.weight}"
      end

      def entity(data)
        client_manager.update(client_id, "position", Vector.new(data["position"]["x"], data["position"]["y"], data["position"]["z"]))
        client_manager.update(client_id, "orientation", Vector.new(data["orientation"]["x"], data["orientation"]["y"], data["orientation"]["z"]))

        queue = []
        client_manager.clients.each do |client|
          queue << {username: client["username"], position: pack_vector(client["position"]), orientation: pack_vector(client["orientation"])}
        end

        message = {channel: :game, mode: :player_moved, data: {players: players}}
        message_manager.broadcast(JSON.dump(message), true, GameOverseer::ChannelManager::WORLD)
      end

      def join(data)
        username = data["data"]["username"]
        username_in_use = client_manager.clients.detect { |client| client["username"] == username }
        username_blank = username.length < 1

        unless username_in_use && username_blank
          client_manager.update(client_id, "username", username)

          message = {channel: :game, mode: :join, data: {token: SecureRandom.hex(16), username: username}}
          message_manager.message(client_id, JSON.dump(message), true, GameOverseer::ChannelManager::HANDSHAKE)
        else
        end
      end

      def leave(data)
        message = {channel: :game, mode: "player_left", data: {client_id: client_id}}
        message_manager.broadcast(JSON.dump(message), true, GameOverseer::ChannelManager::WORLD)
      end

      def client_disconnected(client_id)
        message = {channel: :game, mode: "player_left", data: {client_id: client_id}}
        message_manager.broadcast(JSON.dump(message), true, GameOverseer::ChannelManager::WORLD)
      end

      def version
        "1.0.0"
      end
    end
  end
end