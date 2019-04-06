# A cube placed on to the map grid
class Voxel < Entity
  def default_texture; Texture.get(:missing) end
  def texture_up;    default_texture end
  def texture_down;  default_texture end
  def texture_left;  default_texture end
  def texture_right; default_texture end
  def texture_front; default_texture end
  def texture_back;  default_texture end

  def build_face(type, x, y)
    vertices, normals, colors = [], [], []
    norm = normal(type)
    colour = color(type)

    case type
    when :up
      vertices << Vector.new(x,              0, y)              # TOP LEFT
      vertices << Vector.new(x + @tile_size, 0, y)              # TOP RIGHT
      vertices << Vector.new(x,              0, y + @tile_size) # BOTTOM LEFT

      vertices << Vector.new(x + @tile_size, 0, y)              # TOP RIGHT
      vertices << Vector.new(x + @tile_size, 0, y + @tile_size) # BOTTOM RIGHT
      vertices << Vector.new(x,              0, y + @tile_size) # BOTTOM LEFT
      colour = color(:up)

    when :down
      vertices << Vector.new(x + @tile_size, @tile_size, y)              # TOP LEFT
      vertices << Vector.new(x             , @tile_size, y)              # TOP RIGHT
      vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # BOTTOM LEFT

      vertices << Vector.new(x, @tile_size,              y)              # TOP RIGHT
      vertices << Vector.new(x, @tile_size,              y + @tile_size) # BOTTOM RIGHT
      vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # BOTTOM LEFT
      colour = color(:down)

    when :left
      norm = normal(:left)
      vertices << Vector.new(x, @tile_size, y)              # TOP LEFT
      vertices << Vector.new(x, @tile_size, y + @tile_size) # TOP RIGHT
      vertices << Vector.new(x, 0,          y)              # BOTTOM LEFT

      vertices << Vector.new(x, @tile_size, y + @tile_size) # TOP RIGHT
      vertices << Vector.new(x, 0,          y + @tile_size) # BOTTOM RIGHT
      vertices << Vector.new(x, 0,          y)              # BOTTOM LEFT
      colour = color(:left)

    when :right
      norm = normal(:right)
      vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # TOP LEFT
      vertices << Vector.new(x + @tile_size, @tile_size, y)              # TOP RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y + @tile_size) # BOTTOM LEFT

      vertices << Vector.new(x + @tile_size, @tile_size, y)              # TOP RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y)              # BOTTOM RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y + @tile_size) # BOTTOM LEFT
      colour = color(:right)

    when :front
      norm = normal(:front)
      vertices << Vector.new(x + @tile_size, @tile_size, y) # TOP LEFT
      vertices << Vector.new(x,              @tile_size, y) # TOP RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y) # BOTTOM LEFT

      vertices << Vector.new(x,              @tile_size, y) # TOP RIGHT
      vertices << Vector.new(x,              0,          y) # BOTTOM RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y) # BOTTOM LEFT
      colour = color(:front)

    when :back # done
      norm = normal(:back)
      vertices << Vector.new(x,              @tile_size, y + @tile_size) # TOP LEFT
      vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # TOP RIGHT
      vertices << Vector.new(x,              0,          y + @tile_size) # BOTTOM LEFT

      vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # TOP RIGHT
      vertices << Vector.new(x + @tile_size, 0,          y + @tile_size) # BOTTOM RIGHT
      vertices << Vector.new(x,              0,          y + @tile_size) # BOTTOM LEFT
      colour = color(:back)
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
    when :right
      Vector.new(1.0, 0.0, 0)
    when :front
      Vector.new(0.0, 0.0, 1.0)
    when :back
      Vector.new(0.0, 0.0, -1.0)
    end
  end

  def texture(direction)
    case direction
    when :up
      texture_up
    when :down
      texture_down
    when :left
      texture_left
    when :right
      texture_right
    when :front
      texture_front
    when :back
      texture_back
    end
  end

  def color(direction)
    unless direction.is_a?(Symbol)
      Vector.new(
        gosu_color.red / 255.0,
        gosu_color.green / 255.0,
        gosu_color.blue / 255.0
      )
    else
      case direction
      when :up
        Vector.new(1, 1, 1)
      when :down
        Vector.new(0.8, 0.8, 0.8)
      when :left
        Vector.new(1, 1, 1)
      when :right
        Vector.new(0.8, 0.8, 0.8)
      when :front
        Vector.new(0.4, 0.4, 0.4)
      when :back
        Vector.new(0.6, 0.6, 0.6)
      end
    end
  end
end