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

  def can_move?(normalized, speed)
    bool = false

    # Disable Thing's collision while checking if it can move
    thing_is_collidable = @thing.collidable?
    @thing.collidable = false

    x_slot = @thing.map.grid.dig((@thing.position.x + normalized.x + (normalized.x * @min_wall_distance)).to_i, @thing.position.z.to_i)
    z_slot = @thing.map.grid.dig(@thing.position.x.to_i, (@thing.position.z + normalized.z + (normalized.z * @min_wall_distance)).to_i)

    nx = Vector.new(normalized.x)
    nz = Vector.new(0, 0, normalized.z)

    if (x_slot && !x_slot.collidable?) && (z_slot && !z_slot.collidable?)
      bool = true
    elsif (x_slot && !x_slot.collidable?)
      bool = true
    elsif (z_slot && !z_slot.collidable?)
      bool = true
    end

    @thing.collidable = thing_is_collidable

    return bool
  end

  def move(x, z)
    @thing.position.x = x
    @thing.position.z = z
  end

  def move_towards(normalized, speed)
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
      puts "Failed to MOVE"
      false
    end
  end
end