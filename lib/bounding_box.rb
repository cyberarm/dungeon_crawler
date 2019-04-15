class BoundingBox
  attr_reader :min, :max
  def initialize(min = Vector.new, max = Vector.new)
    raise "min must be a vector!" unless min.is_a?(Vector)
    raise "max must be a vector!" unless max.is_a?(Vector)
    @min = min
    @max = max
  end

  # Fit to an array of vertices
  def shrink_wrap!(vertices)
    @min = vertices.sample
    @max = vertices.sample

    vertices.each do |vert|
      @min = vert.clone if vert.sum < @min.sum
      @max = vert.clone if vert.sum > @max.sum
    end
  end

  def intersect?(other)
    (@min.x <= other.max.x && @max.x >= other.min.x) &&
    (@min.y <= other.max.y && @max.y >= other.min.y) &&
    (@min.z <= other.max.z && @max.z >= other.min.z)
  end

  def point_inside?(vector)
    vector.x.between?(@min.x, @max.x) &&
    vector.y.between?(@min.y, @max.y) &&
    vector.z.between?(@min.z, @max.z)
  end

  def transpose(vector)
    BoundingBox.new(@min + vector, @max + vector)
  end

  def volume
    width * height * depth
  end

  def width
    @max.x - @min.x
  end

  def height
    @max.y - @min.y
  end

  def depth
    @max.z - @min.z
  end

  def clone
    BoundingBox.new(@min.clone, @max.clone)
  end

  def to_s
    "<BoundingBox @min=#{@min}, @max=#{@max}>"
  end
end