class Entity
  def initialize(map, x, y)
    @map = map
    @x, @y = x, y
    @faces = []
    @collidable = true
    @tile_size = 1.0

    construct!

    setup
  end

  def construct!
    raise RuntimeError, "Construct must be overridden!"
  end

  def setup
  end

  def faces
    @faces
  end

  def collidable?
    @collidable
  end

  def collidable=(bool)
    @collidable = bool
  end
end