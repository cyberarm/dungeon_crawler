class RisingDoorBehavior < Behavior
  def setup
    @door_speed = 0.6 # move by n every second
    @open_pos = 0.99
    @closed_pos = 0

    @opening = true
    @closed_time = 0
  end

  def update
    if @opening
      @opening = false if open?
      @closed_time = 0

      open_door unless open?
    else
      if closed?
        @closed_time += Window.instance.delta
        @opening = true if @closed_time > 2.0
      end

      close_door unless closed?
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