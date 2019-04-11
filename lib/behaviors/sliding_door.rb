class SlidingDoorBehavior < Behavior
  def setup
    @door_speed = 0.6 # move by n every second
    @position = @thing.position.clone
    @end_pos = 0.99

    case @thing.options[:form]
    when :left_to_right
      @axis = :x
    when :front_to_back
      @axis = :z
    end
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

  def open_door
    @thing.position.send(:"#{@axis}=", @thing.position.send(@axis) + @door_speed * Window.instance.delta)

    if (@thing.position - @position).send(@axis) > @end_pos
      @thing.position.send(:"#{@axis}=", @position.send(@axis) + @end_pos)
      @thing.collidable = false
    end
  end

  def close_door
    @thing.position.send(:"#{@axis}=", @thing.position.send(@axis) - @door_speed * Window.instance.delta)

    if (@thing.position - @position).send(@axis) < 0
      @thing.position.send(:"#{@axis}=", @position.send(@axis) + 0)
      @thing.collidable = true
    end
  end
end