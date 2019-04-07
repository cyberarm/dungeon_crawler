class Face
  include OpenGL

  attr_accessor :texture
  attr_reader :vertices, :normals, :colors, :uvs, :texture, :brightness
  def initialize(vertices, normals, colors, uvs = nil, texture = nil)
    @vertices = vertices
    @normals  = normals
    @colors   = colors
    @brightness = 1.0

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
      glColor3f(color.red, color.green, color.blue)

      glVertex3f(vertex.x, vertex.y, vertex.z)
    end
  end
end