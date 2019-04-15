class Ray
  def initialize(origin, direction)
    @origin  = origin
    @direction = direction

    @inverse_direction = @direction.inverse
  end

  def intersect?(intersectable)
    if intersectable.is_a?(BoundingBox)
      intersect_bounding_box?(intersectable)
    # elsif intersectable.is_a?(Ray)
      # intersect_ray?(intersectable)
    else
      raise NotImplementedError, "Ray intersection test for #{intersectable.class} not implemented."
    end
  end

  # Based on: https://tavianator.com/fast-branchless-raybounding-box-intersections/
  def intersect_bounding_box?(box)
    tx1 = (box.min.x - @origin.x) * @inverse_direction.x
    tx2 = (box.max.x - @origin.x) * @inverse_direction.x

    tmin = [tx1, tx2].min
    tmax = [tx1, tx2].max

    ty1 = (box.min.y - @origin.y) * @inverse_direction.y
    ty2 = (box.max.y - @origin.y) * @inverse_direction.y

    tmin = [tmin, [ty1, ty2].min].max
    tmax = [tmax, [ty1, ty2].max].min

    tz1 = (box.min.z - @origin.z) * @inverse_direction.z
    tz2 = (box.max.z - @origin.z) * @inverse_direction.z

    tmin = [tmin, [tz1, tz2].min].max
    tmax = [tmax, [tz1, tz2].max].min

    return tmax >= tmin;
  end

  # def intersect_ray?(ray)
  # end
end