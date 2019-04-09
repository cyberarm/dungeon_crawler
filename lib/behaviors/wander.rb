class WanderBehavior < Behavior
  def setup
    @goal = Vector.new(@thing.position.x, 0, @thing.position.z)
    @direction = Vector.new
    @speed = @options[:speed] ? @options[:speed] : 1.0
    @min_wall_distance = 0.5
  end

  def update
    if at_goal?
      choose_goal
    else
      if true#facing?(@goal)
        move_towards(@direction, @speed * Window.instance.delta)
      else
        turn_towards(@goal)
      end
    end
  end

  def at_goal?
    pos = @thing.position
    (@goal - pos).sum.abs <= 0.05
  end

  def choose_goal
    pos = @thing.position
    map = @thing.map
    neighbors = map.neighbors((pos.x).to_i, (pos.z).to_i)

    choices = []
    neighbors.each do |side, hash|
      slot = hash[:slot]
      if slot && slot.voxel.is_a?(Floor) && !slot.thing
        choices << Vector.new(slot.voxel.position.x + 0.5, side, slot.voxel.position.z + 0.5)
      end
    end

    choice = choices[rand(choices.size-1)]
    case choice.y
    when :left
      @direction = Vector.new(-1)
    when :right
      @direction = Vector.new(1)
    when :front
      @direction = Vector.new(0, 0, -1)
    when :back
      @direction = Vector.new(0, 0, 1)
    end

    choice.y = 0
    @goal = choice
  end
end