class RisingDoorBehavior < Behavior
  def setup
    @door_speed = 0.6 # move by n every second
    @open_pos = 0.99
    @closed_pos = 0
  end

  def update
    nearby = @thing.map.players.detect do |player|
      @thing.position.gl_distance2d(player.position) < 2.0
    end

    if nearby
      open_door
    else
      close_door
    end

  end

  def open?
    @thing.position.y == @open_pos
  end

  def closed?
    @thing.position.y == @closed_pos
  end

  def open_door
    @thing.position.y += @door_speed * Window.instance.delta
    if @thing.position.y > @open_pos
      @thing.position.y = @open_pos
      @thing.collidable = false
    end
  end

  def close_door
    @thing.position.y -= @door_speed * Window.instance.delta

    if @thing.position.y < @closed_pos
      @thing.position.y = @closed_pos
      @thing.collidable = true
    end
  end
end