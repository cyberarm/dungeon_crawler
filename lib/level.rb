class Level
  include OpenGL

  class Quad
    include OpenGL
    def initialize(vertices, normals, colors)
      @vertices = vertices
      @normals  = normals
      @colors   = colors
    end

    def draw
      @vertices.each_with_index do |vertex, i|
        normal = @normals[i]
        color  = @colors[i]

        glVertex3f(vertex.x, vertex.y, vertex.z)
        glNormal3f(normal.x, normal.y, normal.z)
        glColor3f(color.x, color.y, color.z)
      end
    end
  end

  def initialize(options = {})
    @options = options
    @map = options[:map]
    @tile_size = 1.0

    @quads = []

    process_map
  end

  def process_map
    @map.height.times do |y|
      @map.height.times do |x|
        tile = @map.tiles[x][y]

        build_quad(tile, x, y)
      end
    end
  end

  def build_quad(tile, x, y)
    case tile[:type]
    when :floor
      build_face(:floor, tile, x, y)
    when :wall
      neighbors = @map.neighbors(x, y)

      neighbors.each do |side, tile|
        next unless tile

        build_face(side, tile, x, y)
      end
    end
  end

  def build_face(type, tile, x, y)
    vertices, normals, colors = [], [], []
    norm = normal(:up)

    case type
    when :floor
      vertices << Vector.new(x,              0, y) # TOP LEFT
      vertices << Vector.new(x + @tile_size, 0, y) # TOP RIGHT
      vertices << Vector.new(x + @tile_size, 0, y + @tile_size) # BOTTOM RIGHT
      vertices << Vector.new(x,              0, y + @tile_size) # BOTTOM LEFT

    when :left
      norm = normal(:left)

    when :right
      norm = normal(:right)

    when :front
      norm = normal(:front)

    when :back
      norm = normal(:back)

    end

    normals << norm
    normals << norm
    normals << norm
    normals << norm

    colors << color(tile[:color])
    colors << color(tile[:color])
    colors << color(tile[:color])
    colors << color(tile[:color])

    @quads << Quad.new(vertices, normals, colors)
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

  def color(gosu_color)
    Vector.new(
      gosu_color.red / 255.0,
      gosu_color.green / 255.0,
      gosu_color.blue / 255.0
    )
  end

  def draw
    glBegin(GL_QUADS)
      @quads.each do |quad|
        quad.draw
      end
    glEnd
  end
end