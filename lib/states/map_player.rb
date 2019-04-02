class MapPlayer < State
  def setup
    @keymap = {
      Gosu::KbW => :forward,
      Gosu::KbS => :backward,
      Gosu::KbA => :turn_left,
      Gosu::KbD => :turn_right,
    }

    @keys   = {}

    @player = Player.new(window: @options[:window], x: @options[:map].position.first, y: @options[:map].position.last)
    @level  = Level.new(map: @options[:map])
  end

  def draw
    @player.camera
    @level.draw

    @window.handle_gl_error
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