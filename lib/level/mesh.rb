class Level
  class Mesh

    attr_reader :faces
    def initialize(map:, light_level: 1.0)
      @light_level = light_level
      @map = map
      @faces = []
      @tile_size = 1.0

      process_map
    end

    def process_map
      @map.height.times do |y|
        @map.width.times do |x|
          tile = @map.tiles[x][y]

          build_quad(tile, x, y)
        end
      end
    end

    def build_quad(tile, x, y)
      case tile[:type]
      when :floor
        build_face(:up, tile, x, y)
        build_face(:down, tile, x, y)
      when :wall
        neighbors = @map.neighbors(x, y)

        neighbors.each do |side, hash|
          _tile = hash[:tile]

          next unless side
          next unless _tile
          next unless _tile[:type] == :floor

          build_face(side, tile, x, y)
        end
      end
    end

    def build_face(type, tile, x, y)
      vertices, normals, colors = [], [], []
      norm = normal(:up)
      colour = color(tile[:color])

      case type
      when :up
        vertices << Vector.new(x,              0, y)              # TOP LEFT
        vertices << Vector.new(x + @tile_size, 0, y)              # TOP RIGHT
        vertices << Vector.new(x,              0, y + @tile_size) # BOTTOM LEFT

        vertices << Vector.new(x + @tile_size, 0, y)              # TOP RIGHT
        vertices << Vector.new(x + @tile_size, 0, y + @tile_size) # BOTTOM RIGHT
        vertices << Vector.new(x,              0, y + @tile_size) # BOTTOM LEFT
        colour = color(0, :up)

      when :down
        vertices << Vector.new(x + @tile_size, @tile_size, y)              # TOP LEFT
        vertices << Vector.new(x             , @tile_size, y)              # TOP RIGHT
        vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # BOTTOM LEFT

        vertices << Vector.new(x, @tile_size,              y)              # TOP RIGHT
        vertices << Vector.new(x, @tile_size,              y + @tile_size) # BOTTOM RIGHT
        vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # BOTTOM LEFT
        colour = color(0, :down)

      when :left
        norm = normal(:left)
        vertices << Vector.new(x, @tile_size, y)              # TOP LEFT
        vertices << Vector.new(x, @tile_size, y + @tile_size) # TOP RIGHT
        vertices << Vector.new(x, 0,          y)              # BOTTOM LEFT

        vertices << Vector.new(x, @tile_size, y + @tile_size) # TOP RIGHT
        vertices << Vector.new(x, 0,          y + @tile_size) # BOTTOM RIGHT
        vertices << Vector.new(x, 0,          y)              # BOTTOM LEFT
        colour = color(0, :left)

      when :right
        norm = normal(:right)
        vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # TOP LEFT
        vertices << Vector.new(x + @tile_size, @tile_size, y)              # TOP RIGHT
        vertices << Vector.new(x + @tile_size, 0,          y + @tile_size) # BOTTOM LEFT

        vertices << Vector.new(x + @tile_size, @tile_size, y)              # TOP RIGHT
        vertices << Vector.new(x + @tile_size, 0,          y)              # BOTTOM RIGHT
        vertices << Vector.new(x + @tile_size, 0,          y + @tile_size) # BOTTOM LEFT
        colour = color(0, :right)

      when :front
        norm = normal(:front)
        vertices << Vector.new(x + @tile_size, @tile_size, y) # TOP LEFT
        vertices << Vector.new(x,              @tile_size, y) # TOP RIGHT
        vertices << Vector.new(x + @tile_size, 0,          y) # BOTTOM LEFT

        vertices << Vector.new(x,              @tile_size, y) # TOP RIGHT
        vertices << Vector.new(x,              0,          y) # BOTTOM RIGHT
        vertices << Vector.new(x + @tile_size, 0,          y) # BOTTOM LEFT
        colour = color(0, :front)

      when :back # done
        norm = normal(:back)
        vertices << Vector.new(x,              @tile_size, y + @tile_size) # TOP LEFT
        vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # TOP RIGHT
        vertices << Vector.new(x,              0,          y + @tile_size) # BOTTOM LEFT

        vertices << Vector.new(x + @tile_size, @tile_size, y + @tile_size) # TOP RIGHT
        vertices << Vector.new(x + @tile_size, 0,          y + @tile_size) # BOTTOM RIGHT
        vertices << Vector.new(x,              0,          y + @tile_size) # BOTTOM LEFT
        colour = color(0, :back)
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
        Texture.get("floor")
      when :down
        Texture.get("ceiling")
      when :left
        Texture.get("wall")
      when :right
        Texture.get("wall")
      when :front
        Texture.get("wall")
      when :back
        Texture.get("wall")
      end
    end

    def color(gosu_color, direction = nil)
      unless direction
        Vector.new(
          gosu_color.red / 255.0,
          gosu_color.green / 255.0,
          gosu_color.blue / 255.0
        )
      else
        case direction
        when :up
          Vector.new(1 * @light_level, 1 * @light_level, 1 * @light_level)
        when :down
          Vector.new(0.8 * @light_level, 0.8 * @light_level, 0.8 * @light_level)
        when :left
          Vector.new(1 * @light_level, 1 * @light_level, 1 * @light_level)
        when :right
          Vector.new(0.8 * @light_level, 0.8 * @light_level, 0.8 * @light_level)
        when :front
          Vector.new(0.4 * @light_level, 0.4 * @light_level, 0.4 * @light_level)
        when :back
          Vector.new(0.6 * @light_level, 0.6 * @light_level, 0.6 * @light_level)
        end
      end
    end
  end
end