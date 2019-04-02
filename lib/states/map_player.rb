class MapPlayer < State
  def setup
    @keymap = {
      Gosu::KbW => :forward,
      Gosu::KbS => :backward,
      Gosu::KbA => :turn_left,
      Gosu::KbD => :turn_right,
    }

    @keys   = {}

    @player = Player.new
  end

  def draw
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

  def button_id(id)
    @keys.delete(id)
  end
end