class MapPlayer < State
  def setup
    @keymap = {
      Gosu::KbW => :forward,
      Gosu::KbS => :backward,
      Gosu::KbA => :strafe_left,
      Gosu::KbD => :strafe_right,

      Gosu::KbUp => :forward,
      Gosu::KbDown => :backward,
      Gosu::KbLeft => :turn_left,
      Gosu::KbRight => :turn_right,
    }

    @keys   = {}

    @window = @options[:window]
    @map    = @options[:map]
    @player = Player.new(window: @window, map: @map, x: @map.position.first, y: @map.position.last)
    @map.players << @player
    @level  = Level.new(map: @map, window: @window)

    @font = Gosu::Font.new(28)
    @map.positional_audio.entity = @player
    @minimap_scale = 0.5
    @minimap_size = 128

    @options[:server_host] = "localhost"
    @options[:server_port] = 56789
    # @network_server = Network::Server.new
    # @network_server.run_in_background do |server|
    #   server.broadcast(:heartbeat, true, "#{Network.time}")
    # end

    # @network_client = Network::Client.new(@options[:server_host], @options[:server_port])
    # @network_client.run
  end

  def draw
    @window.gl(-10) do
      @player.camera
      @level.draw

      @window.handle_gl_error
    end

    @player.draw

    @font.draw_text(
      "FPS: #{Gosu.fps}\nPlayer X: #{@player.position.x.round(1)}, Y: #{@player.position.y.round(1)}, Z: #{@player.position.z.round(1)}\nPlayer Roll: #{@player.orientation.x.round(1)}, Yaw: #{@player.orientation.y.round(1)}, Pitch: #{@player.orientation.z.round(1)}", 10, 10, 10)

    minimap = Gosu.render(@minimap_size, @minimap_size) do
      # BACKGROUND
      Gosu.draw_rect(
        0, 0,
        @minimap_size, @minimap_size,
        Gosu::Color::BLACK
      )

      Gosu.scale(@minimap_scale, @minimap_scale) do
        Gosu.rotate(@player.orientation.y, @minimap_size, @minimap_size) do
          Gosu.translate(-(@player.position.x * @map.size) + @minimap_size, -(@player.position.z * @map.size) + @minimap_size) do
            @map.draw

            # PLAYER
            Gosu.draw_rect(
              @player.position.x * @map.size, @player.position.z * @map.size,
              @map.size, @map.size,
              Gosu::Color::RED
            )

            Gosu.rotate(@player.orientation.y, @player.position.x * @map.size + @map.size/2, @player.position.z * @map.size + @map.size/2) do
              # PLAYER DIRECTION
              Gosu.draw_line(
                @player.position.x * @map.size + @map.size / 2,
                @player.position.z * @map.size, Gosu::Color::GREEN,
                @player.position.x * @map.size + @map.size / 2,
                @player.position.z * @map.size - @map.size, Gosu::Color::GREEN
              )
            end
          end
        end
      end
    end

    minimap.draw(@window.width  - minimap.width, 0, 0)
  end

  def update
    @player.orientation.x = 0 # Player Roll

    @keys.each do |key, value|
      function = @keymap[key]
      next unless function

      @player.send(function)
    end

    @player.update
    @map.update
    @level.update
  end

  def button_down(id)
    @keys[id] = true
  end

  def button_up(id)
    @keys.delete(id)
  end
end