class Wall < Voxel
  def setup
    @collidable = true
  end

  def construct!
    neighbors = @map.neighbors(@x, @y)

    neighbors.each do |side, hash|
      slot = hash[:slot]

      next unless side
      next unless slot
      next unless slot.voxel.is_a?(Floor)

      build_face(side, @x, @y)
    end
  end

  def default_texture
    Texture.get("brick_wall")
  end
end