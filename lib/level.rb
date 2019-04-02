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
        next if tile[:type] == :wall

        vertices, normals, colors = [], [], []
        vertices << Vector.new(x,              0, y)
        vertices << Vector.new(x + @tile_size, 0, y)
        vertices << Vector.new(x,              0, y + @tile_size)
        vertices << Vector.new(x + @tile_size, 0, y + @tile_size)

        normals << normal(:up)
        normals << normal(:up)
        normals << normal(:up)
        normals << normal(:up)

        colors << color(tile[:color])
        colors << color(tile[:color])
        colors << color(tile[:color])
        colors << color(tile[:color])

        @quads << Quad.new(vertices, normals, colors)
      end
    end
  end

  def normal(direction)
    case direction
    when :up
      Vector.new(0, 1.0, 0)
    when :down
    when :left
    when :right
    when :back
    when :front
    end
  end

  def color(gosu_color)
    Vector.new(
      gosu_color.red / 255.0,
      gosu_color.green / 255.0,
      gosu_color.blue / 255.0
    )
    # Vector.new(
    #   1.0,
    #   1.0,
    #   1.0
    # )
  end

  def draw
    glBegin(GL_QUADS)
      @quads.each do |quad|
        quad.draw
      end
    glEnd
  end
end