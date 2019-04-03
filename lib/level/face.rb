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