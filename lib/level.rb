class Level
  include OpenGL

  def initialize(options = {})
    @options = options
    @window = options[:window]
    @map = options[:map]
    @tile_size = 1.0

    @list_id = glGenLists(1)
    @list_filled = false

    @floor = Texture.new("./../assets/floor.png").id
    @wall  = Texture.new("./../assets/wall.png").id

    @faces = []
    @textures = [nil, @floor, @wall]

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
      vertices << Vector.new(x,              0, y) # TOP LEFT
      vertices << Vector.new(x + @tile_size, 0, y) # TOP RIGHT
      vertices << Vector.new(x,              0, y + @tile_size) # BOTTOM LEFT

      vertices << Vector.new(x + @tile_size, 0, y) # TOP RIGHT
      vertices << Vector.new(x + @tile_size, 0, y + @tile_size) # BOTTOM RIGHT
      vertices << Vector.new(x,              0, y + @tile_size) # BOTTOM LEFT
      colour = color(0, :up)

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
      @floor
    when :down
      @wall
    when :left
      @wall
    when :right
      @wall
    when :front
      @wall
    when :back
      @wall
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
        Vector.new(1, 1, 1)
      when :down
        Vector.new(1, 1, 1)
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

  def draw
    unless @list_filled
      @list_filled = true

      glNewList(@list_id, GL_COMPILE)
        render
      glEndList
    else
      glCallList(@list_id)
    end
  end

  def render
    @textures.each do |texture|
      if texture
        glEnable(GL_TEXTURE_2D)
        glBindTexture(GL_TEXTURE_2D, texture)
      end

        glBegin(GL_TRIANGLES)
          @faces.select {|f| f.texture == texture}.each do |face|
            face.draw
          end
        glEnd

        @window.handle_gl_error
        glDisable(GL_TEXTURE_2D) if texture
      end
  end


  class Face
    include OpenGL

    attr_accessor :texture
    def initialize(vertices, normals, colors, uvs = nil, texture = nil)
      @vertices = vertices
      @normals  = normals
      @colors   = colors

      @uvs      = uvs
      @texture  = texture
    end

    def draw
      @vertices.each_with_index do |vertex, i|
        normal = @normals[i]
        color  = @colors[i]

        if @texture
          uv  = @uvs[i]

          glTexCoord2f(uv.x, uv.y)
        end
        glNormal3f(normal.x, normal.y, normal.z)
        glColor3f(color.x, color.y, color.z)

        glVertex3f(vertex.x, vertex.y, vertex.z)
      end
    end
  end

  class Texture
    include OpenGL
    def initialize(texture_path)
      @texture = Gosu::Image.new(texture_path, retro: true)
      array_of_pixels = @texture.to_blob

      tex_names_buf = ' ' * 8
      glGenTextures(1, tex_names_buf)
      @texture_id = tex_names_buf.unpack('L2').first

      glBindTexture(GL_TEXTURE_2D, @texture_id)
      glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, @texture.width, @texture.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, array_of_pixels)
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
      glGenerateMipmap(GL_TEXTURE_2D)

      @texture = nil
    end

    def id
      @texture_id
    end
  end
end