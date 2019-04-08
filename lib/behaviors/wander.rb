class WanderBehavior < Behavior
  def setup
    @goal = Vector.new(@thing.position.x, 0, @thing.position.z)
    @speed = @options[:speed] ? @options[:speed] : 0.1
  end

  def update
    @thing.orientation.y += 0.1
    if at_goal?
      choose_goal
    else
      move_towards(@goal.x, @goal.z, @speed)
    end
  end

  def at_goal?
    false
  end

  def choose_goal
  end
end