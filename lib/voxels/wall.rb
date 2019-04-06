class Wall < Voxel
  def setup
    @collidable = true
  end

  def construct!
    neighbors = @map.neighbors(@x, @y)

    neighbors.each do |side, hash|
      _tile = hash[:tile]

      next unless side
      next unless _tile
      next unless _tile[:type] == :floor

      build_face(side, @x, @y)
    end
  end

  def default_texture
    Texture.get("wall")
  end
end