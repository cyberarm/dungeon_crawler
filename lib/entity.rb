class Entity
  attr_reader :position
  def initialize(map, x, y, options = {})
    @map = map
    @x, @y = x, y
    @position = Vector.new(@x, 0, @y)
    @options = options

    @faces = []
    @collidable = true
    @tile_size = 1.0

    setup
  end

  def construct!
    raise RuntimeError, "Construct must be overridden!"
  end

  def setup
  end

  def draw
  end

  def update
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