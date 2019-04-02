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
    @player = Player.new(window: @window, x: @map.position.first, y: @map.position.last)
    @level  = Level.new(map: @options[:map])

    @font = Gosu::Font.new(28)
  end

  def draw
    @window.gl(-10) do
      @player.camera
      @level.draw

      @window.handle_gl_error
    end

    @font.draw_text("FPS: #{Gosu.fps}\nPlayer X: #{@player.position.x.round(1)}, Y: #{@player.position.y.round(1)}, Z: #{@player.position.z.round(1)}", 10, 10, 10)

    Gosu.translate(@window.width - (@map.width * @map.size) * 0.3, 0) do
      Gosu.scale(0.3, 0.3) do
        @map.draw
        Gosu.draw_rect(
          @player.position.x * @map.size-1, @player.position.z * @map.size-1,
          @map.size, @map.size,
          Gosu::Color::RED
        )
        Gosu.rotate(@player.position.y, @player.position.x * @map.size + @map.size/2, @player.position.z * @map.size + @map.size/2) do
          Gosu.draw_line(
            @player.position.x * @map.size + @map.size/2,
            @player.position.z * @map.size, Gosu::Color::GREEN,
            @player.position.x * @map.size + @map.size/2,
            @player.position.z * @map.size - @map.size, Gosu::Color::GREEN
          )
        end
      end
    end
  end

  def update
    @keys.each do |key, value|
      function = @keymap[key]
      next unless function

      @player.send(function)
    end
  end

  def button_down(id)
    @keys[id] = true
  end

  def button_up(id)
    @keys.delete(id)
  end
end