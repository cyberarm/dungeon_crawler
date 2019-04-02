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
    @player = Player.new(window: @window, x: @options[:map].position.first, y: @options[:map].position.last)
    @level  = Level.new(map: @options[:map])

    @font = Gosu::Font.new(28)
  end

  def draw
    @window.gl do
      @player.camera
      @level.draw

      @window.handle_gl_error
    end

    @font.draw_text("FPS: #{Gosu.fps}\nPlayer X: #{@player.position.x.round(1)}, Y: #{@player.position.y.round(1)}, Z: #{@player.position.z.round(1)}", 10, 10, 10)
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