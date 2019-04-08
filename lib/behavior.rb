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

  def can_move?(x, z)
    bool = Vector.new(false, 0, false)
    normalized = Vector.new(x, 0, z).normalized

    # Disable Thing's collision while checking if it can move
    thing_is_collidable = @thing.collidable?
    @thing.collidable = false

    can_move = false
    x_slot = @thing.map.grid.dig((@thing.position.x + normalized.x + (normalized.x * @min_wall_distance)).to_i, @thing.position.z.to_i)
    z_slot = @thing.map.grid.dig(@thing.position.x.to_i, (@thing.position.z + normalized.z + (normalized.z * @min_wall_distance)).to_i)

    nx = Vector.new(normalized.x)
    nz = Vector.new(0, 0, normalized.z)

    if (x_slot && !x_slot.collidable?) && (z_slot && !z_slot.collidable?)
      bool.x = true
      bool.z = true
    elsif (x_slot && !x_slot.collidable?)
      bool.x = true
    elsif (z_slot && !z_slot.collidable?)
      bool.z = true
    end

    @thing.collidable = thing_is_collidable

    return bool
  end

  def move(x, z)
    @thing.position.x = x
    @thing.position.z = z
  end

  def move_towards(x, z, speed)
    normalized = Vector.new(x, 0, z).normalized
    x_slot = @thing.map.grid.dig((@thing.position.x + normalized.x * speed + (normalized.x * @min_wall_distance)).to_i, @thing.position.z.to_i)
    z_slot = @thing.map.grid.dig(@thing.position.x.to_i, (@thing.position.z + normalized.z * speed + (normalized.z * @min_wall_distance)).to_i)

    nx = Vector.new(normalized.x)
    nz = Vector.new(0, 0, normalized.z)

    if (x_slot && !x_slot.collidable?) && (z_slot && !z_slot.collidable?)
      @thing.position += (nx + nz) * speed
    elsif (x_slot && !x_slot.collidable?)
      @thing.position += nx * speed
    elsif (z_slot && !z_slot.collidable?)
      @thing.position += nz * speed
    else
      moved = false
    end
  end
end