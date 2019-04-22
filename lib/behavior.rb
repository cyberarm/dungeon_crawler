class Behavior
  def initialize(thing, options = {})
    raise unless thing.is_a?(Thing)
    @thing = thing
    @min_wall_distance = 0.0
    @options = options

    setup
  end

  def setup
  end

  def update
  end

  def move(vector)
    @thing.position = vector
  end

  def can_move?(direction, speed)
    @thing.map.collision_manager.can_move_thing?(@thing, speed, direction)
  end

  def move_towards(direction, speed)
    @thing.map.collision_manager.move_thing(@thing, speed, direction)
  end
end