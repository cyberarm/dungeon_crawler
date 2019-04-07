# A cube placed on to the map grid
class Voxel < Entity
  def default_texture; Texture.get(:missing) end
  def texture_up;    default_texture end
  def texture_down;  default_texture end
  def texture_left;  default_texture end
  def texture_right; default_texture end
  def texture_front; default_texture end
  def texture_back;  default_texture end

  def build_face(type, x, y, _normal = nil)
    vertices, normals, colors = [], [], []
    norm = normal((_normal ? _normal : type))
    colour = color(type)

    case type
    when :up
      vertices << Vector.new(x,              0, y)              # TOP LEFT
      vertices << Vector.new(x + @tile_size, 0, y)              # TOP RIGHT
      vertices << Vector.new(x,              0, y + @tile_size) # BOTTOM LEFT

      vertices << Vector.new(x + @tile_size, 0, y)              # TOP RIGHT
      vertices << Vector.new(x + @tile_size, 0, y + @tile_size) # BOTTOM RIGHT
      vertices << Vector.new(x,              0, y + @tile_size) # BOTTOM LEFT

    when :down
      vertices << Vector.new(x + @tile_size, @tile_size, y)              # TOP LEFT
      vertices << Vector.new(x             , @tile_size, y)              # TOP RIGHT
      vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # BOTTOM LEFT

      vertices << Vector.new(x,              @tile_size, y)              # TOP RIGHT
      vertices << Vector.new(x,              @tile_size, y + @tile_size) # BOTTOM RIGHT
      vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # BOTTOM LEFT

    when :left
      vertices << Vector.new(x, @tile_size, y)              # TOP LEFT
      vertices << Vector.new(x, @tile_size, y + @tile_size) # TOP RIGHT
      vertices << Vector.new(x, 0,          y)              # BOTTOM LEFT

      vertices << Vector.new(x, @tile_size, y + @tile_size) # TOP RIGHT
      vertices << Vector.new(x, 0,          y + @tile_size) # BOTTOM RIGHT
      vertices << Vector.new(x, 0,          y)              # BOTTOM LEFT

    when :inset_left
      vertices << Vector.new(x, @tile_size, y + @tile_size) # TOP LEFT
      vertices << Vector.new(x, @tile_size, y)              # TOP RIGHT
      vertices << Vector.new(x, 0,          y + @tile_size) # BOTTOM LEFT

      vertices << Vector.new(x, @tile_size, y)              # TOP RIGHT
      vertices << Vector.new(x, 0,          y)              # BOTTOM RIGHT
      vertices << Vector.new(x, 0,          y + @tile_size) # BOTTOM LEFT

    when :right
      vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # TOP LEFT
      vertices << Vector.new(x + @tile_size, @tile_size, y)              # TOP RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y + @tile_size) # BOTTOM LEFT

      vertices << Vector.new(x + @tile_size, @tile_size, y)              # TOP RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y)              # BOTTOM RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y + @tile_size) # BOTTOM LEFT

    when :inset_right
      vertices << Vector.new(x + @tile_size, @tile_size, y)              # TOP LEFT
      vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # TOP RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y)              # BOTTOM LEFT

      vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # TOP RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y + @tile_size) # BOTTOM RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y)              # BOTTOM LEFT

    when :front
      vertices << Vector.new(x + @tile_size, @tile_size, y) # TOP LEFT
      vertices << Vector.new(x,              @tile_size, y) # TOP RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y) # BOTTOM LEFT

      vertices << Vector.new(x,              @tile_size, y) # TOP RIGHT
      vertices << Vector.new(x,              0,          y) # BOTTOM RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y) # BOTTOM LEFT

    when :inset_front
      vertices << Vector.new(x,              @tile_size, y) # TOP LEFT
      vertices << Vector.new(x + @tile_size, @tile_size, y) # TOP RIGHT
      vertices << Vector.new(x,           0,             y) # BOTTOM LEFT

      vertices << Vector.new(x + @tile_size, @tile_size, y) # TOP RIGHT
      vertices << Vector.new(x + @tile_size,          0, y) # BOTTOM RIGHT
      vertices << Vector.new(x,           0,             y) # BOTTOM LEFT

    when :back
      vertices << Vector.new(x,              @tile_size, y + @tile_size) # TOP LEFT
      vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # TOP RIGHT
      vertices << Vector.new(x,              0,          y + @tile_size) # BOTTOM LEFT

      vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # TOP RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y + @tile_size) # BOTTOM RIGHT
      vertices << Vector.new(x,              0,          y + @tile_size) # BOTTOM LEFT

    when :inset_back
      vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # TOP LEFT
      vertices << Vector.new(x,              @tile_size, y + @tile_size) # TOP RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y + @tile_size) # BOTTOM LEFT

      vertices << Vector.new(x,             @tile_size, y + @tile_size) # TOP RIGHT
      vertices << Vector.new(x,             0,          y + @tile_size) # BOTTOM RIGHT
      vertices << Vector.new(x + @tile_size,0,          y + @tile_size) # BOTTOM LEFT
    else
      raise ArgumentError, "Unknown face type: #{type.inspect}"
    end

    normals << norm
    normals << norm
    normals << norm
    normals << norm
    normals << norm
    normals << norm

    colors << colour
    colors << colour
    colors << colour
    colors << colour
    colors << colour
    colors << colour

    @faces << Face.new(vertices, normals, colors, texture_coordinates, texture(type))
  end

  def texture_coordinates
    [
      Vector.new(0, 0), # TOP LEFT
      Vector.new(1, 0), # TOP RIGHT
      Vector.new(0, 1), # BOTTOM LEFT

      Vector.new(1, 0), # TOP RIGHT
      Vector.new(1, 1), # BOTTOM RIGHT
      Vector.new(0, 1)  # BOTTOM LEFT
    ]
  end

  def normal(direction)
    case direction
    when :up
      Vector.new(0, 1.0, 0)
    when :down
      Vector.new(0, -1.0, 0)
    when :left
      Vector.new(-1.0, 0.0, 0)
    when :inset_left
      Vector.new(-1.0, 0.0, 0)
    when :right
      Vector.new(1.0, 0.0, 0)
    when :inset_right
      Vector.new(-1.0, 0.0, 0)
    when :front
      Vector.new(0.0, 0.0, 1.0)
    when :inset_front
      Vector.new(0.0, 0.0, -1.0)
    when :back
      Vector.new(0.0, 0.0, -1.0)
    when :inset_back
      Vector.new(0.0, 0.0, 1.0)
    end
  end

  def texture(direction)
    case direction
    when :up
      texture_up
    when :down
      texture_down
    when :left, :inset_left
      texture_left
    when :right, :inset_right
      texture_right
    when :front, :inset_front
      texture_front
    when :back, :inset_back
      texture_back
    end
  end

  def color(direction)
    unless direction.is_a?(Symbol)
      GLColor.new(
        gosu_color.red / 255.0,
        gosu_color.green / 255.0,
        gosu_color.blue / 255.0
      )
    else
      case direction
      when :up
        GLColor.new(1, 1, 1)
      when :down
        GLColor.new(0.8, 0.8, 0.8)
      when :left, :inset_left
        GLColor.new(1, 1, 1)
      when :right, :inset_right
        GLColor.new(0.8, 0.8, 0.8)
      when :front, :inset_front
        GLColor.new(0.4, 0.4, 0.4)
      when :back, :inset_back
        GLColor.new(0.6, 0.6, 0.6)
      end
    end
  end
end