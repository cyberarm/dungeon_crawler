class Door < Voxel
  def setup
    @collidable = false
  end

  def default_texture; Texture.get("brick_wall") end
  def texture_up; Texture.get("rock_floor") end
  def texture_down; Texture.get("office_ceiling") end

  def construct!
    build_face(:up, @x, @y)
    build_face(:down, @x, @y)

    case @options[:form]
    when :left_to_right
      build_face(:inset_right, @x, @y, :left)
      build_face(:inset_left, @x, @y, :right)
    when :front_to_back
      build_face(:inset_front, @x, @y)
      build_face(:inset_back, @x, @y)
    end
  end
end