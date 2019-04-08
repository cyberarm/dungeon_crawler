class SlidingDoorBehavior < Behavior
  def setup
    @door_speed = 0.1 # move by n every second
    @position = @thing.position.clone
    @end_pos = 0.99
  end

  def update
    open_door
  end

  def open_door
    @thing.position.x += @door_speed * Window.instance.delta

    if (@thing.position - @position).x > @end_pos
      @thing.position.x = @position.x + @end_pos
      @thing.collidable = false
    end
  end

  def close_door
    @thing.position.x -= @door_speed * Window.instance.delta

    if (@thing.position - @position).x < 0
      @thing.position.x = @position.x + 0
      @thing.collidable = true
    end
  end
end