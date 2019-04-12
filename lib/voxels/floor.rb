class Floor < Voxel
  def setup
    @collidable = false
  end

  def construct!
    build_face(:up, @x, @y)
    build_face(:down, @x, @y)
  end

  def texture_up; Texture.get("rock_floor"); end
  def texture_down; Texture.get("office_ceiling"); end
end